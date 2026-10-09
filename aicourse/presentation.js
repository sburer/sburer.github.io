const slides = [...document.querySelectorAll('[data-slide]')];
const previous = document.querySelector('#previousSlide');
const next = document.querySelector('#nextSlide');
const status = document.querySelector('#slideStatus');
const progress = document.querySelector('#presentationProgress');
let current = 0;

function setSlide(index, shouldFocus = false) {
  current = Math.max(0, Math.min(index, slides.length - 1));
  slides.forEach((slide, slideIndex) => {
    const active = slideIndex === current;
    slide.hidden = !active;
    slide.classList.toggle('active', active);
  });
  previous.disabled = current === 0;
  next.disabled = current === slides.length - 1;
  status.textContent = `${current + 1} / ${slides.length}`;
  progress.style.width = `${((current + 1) / slides.length) * 100}%`;
  document.querySelector('.presentation').classList.toggle('presentation-light-controls', slides[current].classList.contains('slide-light') || slides[current].classList.contains('slide-gold'));
  history.replaceState(null, '', `#slide-${current + 1}`);
  if (shouldFocus) document.querySelector('#presentation').focus();
}

previous.addEventListener('click', () => setSlide(current - 1, true));
next.addEventListener('click', () => setSlide(current + 1, true));

document.addEventListener('keydown', (event) => {
  if (event.altKey || event.ctrlKey || event.metaKey) return;
  if (['ArrowRight', ' ', 'PageDown'].includes(event.key)) { event.preventDefault(); setSlide(current + 1, true); }
  if (['ArrowLeft', 'PageUp'].includes(event.key)) { event.preventDefault(); setSlide(current - 1, true); }
  if (event.key === 'Home') { event.preventDefault(); setSlide(0, true); }
  if (event.key === 'End') { event.preventDefault(); setSlide(slides.length - 1, true); }
});

const hashMatch = window.location.hash.match(/^#slide-(\d+)$/);
setSlide(hashMatch ? Number(hashMatch[1]) - 1 : 0);
