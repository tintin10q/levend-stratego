#let img = "plaatjes/"
#let ranks = (
  (rank: 10, name: "Maarschalk", art: img + "maarschalk.png", count: 1),
  (rank: 9,  name: "Generaal",   art: img + "generaal.png",   count: 1),
  (rank: 8,  name: "Kolonel",    art: img + "kolonel.png",    count: 2),
  (rank: 7,  name: "Majoor",     art: img + "majoor.png",     count: 3),
  (rank: 6,  name: "Kapitein",   art: img + "kapitein.png",   count: 4),
  (rank: 5,  name: "Luitenant",  art: img + "luitenant.png",  count: 4),
  (rank: 4,  name: "Sergeant",   art: img + "sergeant.png",   count: 4),
  (rank: 3,  name: "Mineur",     art: img + "mineur.png",     count: 5,  extra: "Verslaat de Bom"),
  (rank: sym.star, name: "Bom",        art: img + "bom.png",        count: 6,  extra: "Mag niet tikken"),
  (rank: 2,  name: "Verkenner",  art: img + "verkenner.png",  count: 8),
  (rank: 1,  name: "Spion",      art: img + "spion.png",      count: 1,  extra: "Verslaat de Maarschalk"),
  (rank: rotate(-20deg, "⚑"), name: "Vlag",       art: img + "vlag.png",       count: 1),
)

// ---- Kaartfunctie ----
#let stratego-card(
  info,
  width: 6cm,
  height: 9cm,
  accent: black, 
  flipped: false,
  extra: none,
  extra-font-size: 12pt,
  rank-font-size: 21pt,
  header-color: black,
) = {
  let rank-label = [#info.rank]
  let art = info.art
  let count = info.count;
  let name = info.name;
  let has-extra = extra != none or "extra" in info;
  let extra = if extra != none {extra} else {info.at("extra", default: "")}


  box(
    width: width,
    height: height,
    radius: 8pt,
    stroke: 2.5pt + accent,
    fill: white,
    clip: true,
  )[
    #grid(
      rows: (auto, 1fr, auto),

      // --- kop: rang + naam ---
      block(
        width: 100%,
        fill: accent,
        inset: (x: 10pt, y: 8pt),
        grid(
          columns: (auto, 1fr),
          align: (left + horizon, right + horizon),
          column-gutter: 8pt,
          text(fill: header-color,  size: rank-font-size, info.name),
          text(font: "Zapf", fill: header-color, weight: "bold", size: 32pt, rank-label),
        ),
      ),

      // --- afbeelding ---
      box(
        width: 100%,
        height: 100%,
        inset: 10pt,
        align(
          center + horizon,
          if flipped {
              scale(x: -100%, image(info.art, width: 130%, fit: "contain"))
           } else {
              image(info.art, width: 130%, height: 130%, fit: "contain")
           }
        ),
      ),


      // Voeg toe hoe vaak de kaartjes bestaan
        block(
            width: 100%,
            inset: (x: 10pt, y: 6pt),
              align(
                center,
                grid(columns: count,
                ..for _ in range(count) {
                    (pad(right: 4pt, square(size: 14pt, stroke: black)),)
                }
                )
              )
        ),

      // --- voet: extra tekst (alleen indien aanwezig) ---
      let extra-content = block(
          width: 100%,
          fill: accent.lighten(80%),
          inset: (y: 9pt),
          align(
            center,
            text(font: "Special Elite", fill: black, style: "italic", size: extra-font-size, extra),
          ),
        ),

      if has-extra {
       extra-content 
      } 
      // otherwise hide it to get good spacing
      else { hide(extra-content) },
    )
  ]
}


/*                          *
 *  Begin van het renderen  *
 *                          */

#let paars = rgb("#c867f8");
#let paars-headers-color = black 

#let geel = rgb(244, 210,61);

// Kaart met informatie 
#set page("a4", margin: (top: 23pt, right: 5pt, left: 5pt, bottom: 5pt), flipped: true)

#let troepenoverzicht(accent, header-color: black) = [
  #pad(align(center, heading(text(1cm, font: "Rye", accent.darken(30%))[Troepenoverzicht])))
]+grid(
  columns: (1fr,1fr,1fr,1fr,1fr),
  gutter: 6pt,
  ..for rank in ranks.slice(0,5) {
        ((stratego-card(rank, accent: accent, header-color: header-color, width: 100%, extra-font-size: 12pt )), )
  }) + grid(
  columns: (1fr,1fr,1fr,1fr,1fr, 1fr),
  gutter: 6pt,
  ..for rank in ranks.slice(5,11) {
        ((stratego-card(rank,  accent: accent, header-color: header-color,width: 100%, extra-font-size: 10pt )), )
  } 
) + align(center, text(12pt, font: "Special Elite")[Gebruik de blokjes om bij te houden hoeveel er nog in het spel zitten. De sleutel tot overwinning is goede communicatie.])

#troepenoverzicht(paars, header-color: paars-headers-color)
#troepenoverzicht(paars, header-color: paars-headers-color)


#troepenoverzicht(geel)
#troepenoverzicht(geel)


// Kaarten om te spelen
#set page("a4", margin: 1cm, flipped: false)

#let kaarten(accent, header-color: black) = grid(
  columns: 3,
  gutter: 6pt,
  ..for rank in ranks {
      for i in range(rank.count) {
        /* Ik flip de helft voor variatie */
        ((stratego-card(rank, accent: accent, header-color: header-color, flipped: calc.odd(i)  )), )
      }
  }
)

#kaarten(paars, header-color: paars-headers-color)

#pagebreak()

#kaarten(geel)


