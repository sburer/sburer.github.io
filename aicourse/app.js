const $ = (selector) => document.querySelector(selector);
const checks = [...document.querySelectorAll('[data-check]')];
const progressText = $('#progressText');
const progressBar = $('#progressBar');
const toolName = $('#toolName');
const toast = $('#toast');

function showToast(message) {
  toast.textContent = message;
  toast.classList.add('show');
  window.clearTimeout(showToast.timer);
  showToast.timer = window.setTimeout(() => toast.classList.remove('show'), 3200);
}

function updateProgress() {
  const done = checks.filter((check) => check.checked).length;
  progressText.textContent = `${done} of ${checks.length} ready`;
  progressBar.style.width = `${(done / checks.length) * 100}%`;
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
    toolName.textContent = button.dataset.tool;
    localStorage.setItem('tocb-tool', button.dataset.tool);
    showToast(`${button.dataset.tool} selected for your course setup.`);
  });
});

const savedTool = localStorage.getItem('tocb-tool');
if (savedTool) {
  const savedButton = document.querySelector(`[data-tool="${savedTool}"]`);
  if (savedButton) savedButton.click();
}

const modal = $('#modal');
$('#overviewButton').addEventListener('click', () => { modal.classList.add('open'); modal.setAttribute('aria-hidden', 'false'); });
$('#helpButton').addEventListener('click', () => { modal.classList.add('open'); modal.setAttribute('aria-hidden', 'false'); });
$('#modalClose').addEventListener('click', () => { modal.classList.remove('open'); modal.setAttribute('aria-hidden', 'true'); });
modal.addEventListener('click', (event) => { if (event.target === modal) { modal.classList.remove('open'); modal.setAttribute('aria-hidden', 'true'); } });

$('#saveReminder').addEventListener('click', () => showToast('Data-responsibility reminder added to your preparation list.'));
$('#reflectionForm').addEventListener('submit', (event) => {
  event.preventDefault();
  const goal = $('#goal').value.trim();
  if (!goal) { showToast('Write a small starting idea first.'); return; }
  localStorage.setItem('tocb-goal', goal);
  showToast('Your idea is saved in this browser. Bring it to class.');
});
$('#goal').value = localStorage.getItem('tocb-goal') || '';
$('#profileButton').addEventListener('click', () => showToast('Participant profile is a prototype-only interaction.'));
