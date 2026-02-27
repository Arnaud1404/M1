import sys, copy
try:
    from pypdf import PdfReader, PdfWriter
except ImportError:
    print("Installation de pypdf nécessaire...")
    sys.exit(1)

input_file = 'slides.pdf'
reader = PdfReader(input_file)
slides = PdfWriter()
notes = PdfWriter()

print(f"Découpage de {len(reader.pages)} pages...")

for page in reader.pages:
    w = float(page.mediabox.right)
    h = float(page.mediabox.top)
    
    # Partie GAUCHE (Slides)
    p_s = copy.deepcopy(page)
    p_s.mediabox.upper_right = (w/2, h)
    slides.add_page(p_s)

    # Partie DROITE (Notes)
    p_n = copy.deepcopy(page)
    p_n.mediabox.upper_left = (w/2, 0)
    notes.add_page(p_n)

with open('PROJECTEUR_slides.pdf', 'wb') as f: slides.write(f)
with open('PERSO_notes.pdf', 'wb') as f: notes.write(f)
print("✅ Terminé ! Fichiers créés.")
