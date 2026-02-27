import sys, copy
try:
    from pypdf import PdfReader, PdfWriter
except ImportError:
    print("Installation de pypdf nécessaire...")
    sys.exit(1)

input_file = 'slides.pdf'
# Nom du fichier de sortie
output_filename = 'NOTES_TABLETTE.pdf'

try:
    reader = PdfReader(input_file)
    writer = PdfWriter()

    print(f"Extraction des notes de {len(reader.pages)} pages...")

    for page in reader.pages:
        # Récupération des dimensions
        w = float(page.mediabox.right)
        h = float(page.mediabox.top)
        
        # --- EXTRACTION PARTIE DROITE (NOTES) ---
        p_note = copy.deepcopy(page)
        
        # On déplace le coin GAUCHE de la zone visible au MILIEU de la page
        # Coordonnées : (X=Moitié, Y=0) et (X=Moitié, Y=Hauteur)
        p_note.mediabox.lower_left = (w/2, 0)
        p_note.mediabox.upper_left = (w/2, h)
        
        writer.add_page(p_note)

    with open(output_filename, 'wb') as f:
        writer.write(f)
    print(f"✅ SUCCÈS ! Fichier créé : {output_filename}")

except FileNotFoundError:
    print("❌ ERREUR : Le fichier 'slides.pdf' est introuvable.")
