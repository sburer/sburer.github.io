const $ = (selector) => document.querySelector(selector);
const checks = [...document.querySelectorAll('[data-check]')];
const progressText = $('#progressText');
const progressBar = $('#progressBar');
const toolName = $('#toolName');
const planName = $('#planName');
const desktopName = $('#desktopName');
const safeSetupLink = $('#safeSetupLink');
const safeSetupText = $('#safeSetupText');
const toast = $('#toast');

const toolDetails = {
  'ChatGPT Work': { plan: 'ChatGPT Plus', desktop: 'ChatGPT desktop app', task: 'a file task in ChatGPT Work', anchor: 'chatgpt', label: 'ChatGPT' },
  'Claude Cowork': { plan: 'Claude Pro', desktop: 'Claude desktop app', task: 'a file task in Claude', anchor: 'claude', label: 'Claude' },
};
let activeTool = 'ChatGPT Work';

function updateToolCopy(tool) {
  const details = toolDetails[tool];
  if (!details) return;
  if (toolName) toolName.textContent = details.task;
  if (planName) planName.textContent = details.plan;
  if (desktopName) desktopName.textContent = details.desktop;
  if (safeSetupLink) safeSetupLink.href = `safe-setup.html#${details.anchor}`;
  if (safeSetupText) safeSetupText.textContent = `Show ${details.label} steps`;
}

function showToast(message) {
  toast.textContent = message;
  toast.classList.add('show');
  window.clearTimeout(showToast.timer);
  showToast.timer = window.setTimeout(() => toast.classList.remove('show'), 3200);
}

function updateProgress() {
  const done = checks.filter((check) => check.checked).length;
  if (progressText) progressText.textContent = `${done} of ${checks.length} ready`;
  if (progressBar) progressBar.style.width = `${(done / checks.length) * 100}%`;
  checks.forEach((check) => localStorage.setItem(`tocb-${activeTool}-${check.dataset.check}`, check.checked));
}

function selectTool(tool, announce = false) {
  if (!toolDetails[tool]) return;
  activeTool = tool;
  document.querySelectorAll('.tool-option').forEach((button) => {
    const selected = button.dataset.tool === tool;
    button.classList.toggle('selected', selected);
    button.setAttribute('aria-pressed', String(selected));
  });
  updateToolCopy(tool);
  checks.forEach((check) => {
    const saved = localStorage.getItem(`tocb-${tool}-${check.dataset.check}`);
    const legacy = tool === 'ChatGPT Work' ? localStorage.getItem(`tocb-${check.dataset.check}`) : null;
    check.checked = (saved ?? legacy) === 'true';
  });
  updateProgress();
  localStorage.setItem('tocb-tool', tool);
  if (announce) showToast(`${toolDetails[tool].label} selected for your course setup.`);
}

checks.forEach((check) => check.addEventListener('change', updateProgress));

document.querySelectorAll('.tool-option').forEach((button) => {
  button.addEventListener('click', () => selectTool(button.dataset.tool, true));
});

const savedTool = localStorage.getItem('tocb-tool');
if (document.querySelector('.tool-option')) selectTool(toolDetails[savedTool] ? savedTool : 'ChatGPT Work');

$('#saveReminder')?.addEventListener('click', () => showToast('Data-responsibility reminder added to your preparation list.'));
