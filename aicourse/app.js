const $ = (selector) => document.querySelector(selector);
const checks = [...document.querySelectorAll('[data-check]')];
const progressText = $('#progressText');
const progressBar = $('#progressBar');
const toolName = $('#toolName');
const toolSetupName = $('#toolSetupName');
const planName = $('#planName');
const desktopName = $('#desktopName');
const toast = $('#toast');

const toolDetails = {
  'ChatGPT Work': { setup: 'ChatGPT', plan: 'ChatGPT Plus', desktop: 'ChatGPT desktop app' },
  'Claude Cowork': { setup: 'Claude', plan: 'Claude Pro', desktop: 'Claude desktop app' },
};

function updateToolCopy(tool) {
  const details = toolDetails[tool];
  if (!details) return;
  if (toolName) toolName.textContent = tool;
  if (toolSetupName) toolSetupName.textContent = details.setup;
  if (planName) planName.textContent = details.plan;
  if (desktopName) desktopName.textContent = details.desktop;
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
  checks.forEach((check) => localStorage.setItem(`tocb-${check.dataset.check}`, check.checked));
}

checks.forEach((check) => {
  check.checked = localStorage.getItem(`tocb-${check.dataset.check}`) === 'true';
  check.addEventListener('change', updateProgress);
});
updateProgress();

document.querySelectorAll('.tool-option').forEach((button) => {
  button.addEventListener('click', () => {
    document.querySelectorAll('.tool-option').forEach((option) => option.classList.remove('selected'));
    button.classList.add('selected');
    updateToolCopy(button.dataset.tool);
    localStorage.setItem('tocb-tool', button.dataset.tool);
    showToast(`${button.dataset.tool} selected for your course setup.`);
  });
});

const savedTool = localStorage.getItem('tocb-tool');
if (savedTool) {
  const savedButton = document.querySelector(`[data-tool="${savedTool}"]`);
  if (savedButton) savedButton.click();
}

$('#saveReminder')?.addEventListener('click', () => showToast('Data-responsibility reminder added to your preparation list.'));
