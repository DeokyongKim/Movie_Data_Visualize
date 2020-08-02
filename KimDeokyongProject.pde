import java.util.Map;

ArrayList fmoviename, moviename, fimgUrl, M_array, G_array, movie_number;
int flag = 0;
int page = 0;
int amount = 100;
int many = 18;
int genre_num = 0, mouse_rank;
int up = 100;

int[] ab = {91, 120};
int[] aw = {1902, 1424};
int[] tb = {264, 264};
int[] ts = {1200, 1217};
int[] tw = {290, 280};

PImage saflix, forsave, audience_best, audience_worst, tomato_best, tomato_soso, tomato_worst;

String[] genre_url = {"", "top_100_action__adventure_movies/", "top_100_animation_movies/", "top_100_art_house__international_movies/", "top_100_classics_movies/", "top_100_comedy_movies/", "top_100_documentary_movies/", "top_100_drama_movies/", "top_100_horror_movies/", "top_100_kids__family_movies/", "top_100_musical__performing_arts_movies/", "top_100_mystery__suspense_movies/", "top_100_romance_movies/", "top_100_science_fiction__fantasy_movies/", "top_100_special_interest_movies/", "top_100_sports__fitness_movies/", "top_100_television_movies/", "top_100_western_movies/"};
String[] genre = {"All Genre", "Action & Adventure", "Animation", "Art House & International", "Classics", "Comedy", "Documentery", "Drama", "Horror", "Kids & Family", "Musical & Performing Arts", "Mystery & Suspense", "Romance", "Science Fiction & Fantasy", "Special Interest", "Sports & Fitness", "Television", "Western"};

class Movie {
  PImage poster;
  String name, poname, rawname, rating, critics, director, actor1, actor2, murl;
  int ix, iy, rx, ry, nx, ny, rank, g, year, playtime, boxoffice = -1, ascore, tscore, amany, tmany;
  String[] Mgenre;
  boolean check = false;
  
  Movie(int r) {
    murl = "https://www.rottentomatoes.com/m/" + (String)moviename.get(r-1);
    ascore = 0;
    tscore = 0;
    amany = 0;
    tmany = 0;
    int didbef = 0;
    rank = (r-1)%100+1;
    g = (int)(r-1)/100;
    rawname = (String)moviename.get(r-1);
    
    //println(rawname);
    
    File mf = dataFile(rawname + ".txt");
    boolean mexist = mf.isFile();
    
    if (mexist == true) {
      String[] lines = loadStrings(rawname + ".txt");
      String tmp = join(lines, "\n");
      String[] line = split(tmp, "\n");
      name = line[0];
      //critics = line[1];
      year = int(line[1]);
      playtime = int(line[2]);
      rating = line[3];
      //boxoffice = int(line[4]);
      director = line[4];
      poster = loadImage(rawname + ".jpg"); 
      //println("////" + rawname + "\n");
      Mgenre = split(lines[5], ":");
    }
    else {
      if (r > 100) {
        for (int i = 0; i<100; i++) {
          if (((Movie)M_array.get(i)).rawname == rawname) {
            name = ((Movie)M_array.get(i)).name;
            poster = ((Movie)M_array.get(i)).poster;
            didbef = 1;
            //println("\n dodo \n");
            break;
          }
        }
      }
      
      
      if (didbef == 0) {
        //println((String)moviename.get(r-1));
        
        String url = "https://www.rottentomatoes.com/m/" + (String)moviename.get(r-1);
        String html = "";
        
        String[] lines = {};
        
        int did = 1;
        while (did == 1) {
          try {
            lines = loadStrings(url);
            html = join(lines, "");
            did = 0;
          } catch (Exception e) {
            did = 1;
          }
        }
        
        //println((String)moviename.get(r-1));
        
        File f = dataFile(rawname + ".jpg");
        boolean exist = f.isFile();
        
        if (exist == true) {
          //println("------here is------ \n");
          poster = loadImage(rawname + ".jpg");
        }
        else {
          fimgUrl = new ArrayList();
          for (int i = 0; i<lines.length; i++) {
            String t = giveMeTextBetween(lines[i], "data-src=\"", "\"");
            if (t != "")
              fimgUrl.add(t);
          }
          
          String imgUrl = (String)fimgUrl.get(10);
          //println(imgUrl);
          poster = loadImage(imgUrl, "jpg");
          forsave = poster.get();
          forsave.save("./data/" + rawname + ".jpg");
        }
   
        name = giveMeTextBetween(html, "\"mop-ratings-wrap__title mop-ratings-wrap__title--top\">", "</h1>");
        for (int i = 0; i< name.length(); i++) {
          if (name.charAt(i) == '&' && i+4 < name.length()) {
            String tocheckthis = name.substring(i, i+5);
            if (tocheckthis.equals("&#39;")) {
              name = name.substring(0, i) + "'" + name.substring(i+5, name.length());
            }
          }
        }
        
        
        String genretmp = giveMeTextBetween(html, "<div class=\"meta-value\">                        ", " </div>                </li>");
        for (int i = 0; i< genretmp.length(); i++) {
          if (genretmp.charAt(i) == '&' && i+4 < genretmp.length()) {
            String tocheckthis = genretmp.substring(i, i+5);
            if (tocheckthis.equals("&amp;")) {
              genretmp = genretmp.substring(0, i) + "&" + genretmp.substring(i+5, genretmp.length());
            }
          }
        }
        Mgenre = split(genretmp, ",");
        Mgenre = trim(Mgenre);
        String Sgenre = join(Mgenre, ":");
        
        println(rawname);
        String temtemhtml = join(lines, "");
        String temporary = giveMeTextBetween(temtemhtml, "href=\"/celebrity/", "\">");
        if (temporary != "") {
          String tmpurl = "https://www.rottentomatoes.com" + "/celebrity/" + temporary;
          String[] tmplines = {};
        
          
          int tmpdid = 1;
          try {
            
            tmplines = loadStrings(tmpurl);
            String nnnnn = join(tmplines, "");
            tmpdid = 0;
          } catch (Exception e) {
            tmpdid = 1;
          }
          
          if (tmpdid == 1) {
            director = "None";
          }
          else {
            for (int j = 0; j<tmplines.length; j++) {
              String tmpman = giveMeTextBetween(tmplines[j], "<h1 class=\"celebrity-bio__h1\">", "</h1>");
              if (tmpman != "") {
                director = tmpman;
                break;
              }
            }
          }
        }
        else {
          director = "None";
        }
        
        year = int(giveMeTextBetween(html, "<time datetime=\"", "-"));
        playtime = int(giveMeTextBetween(html, "<time datetime=\"P", "M"));
        rating = giveMeTextBetween(html, "<div class=\"meta-value\">", " ");
        //critics = giveMeTextBetween(html, "<p class=\"mop-ratings-wrap__text mop-ratings-wrap__text--concensus\">", "</p>");
        //for (int prompt = 0; prompt< critics.length(); prompt++) {
        //  if (prompt+4 < critics.length() && critics.charAt(prompt) == '<') {
        //    String tocheckthis = critics.substring(prompt, prompt+4);
        //    if (tocheckthis.equals("<em>")) {
        //      critics = critics.substring(0, prompt) + critics.substring(prompt+4, name.length());
        //    }
        //  }
        //  if (critics.charAt(prompt) == '<' && prompt+4 < critics.length()) {
        //    String tocheckthis = critics.substring(prompt, prompt+5);
        //    if (tocheckthis.equals("</em>")) {
        //      critics = critics.substring(0, prompt) + critics.substring(prompt+5, name.length());
        //    }
        //  }
        //  if (critics.charAt(prompt) == '"') {

        //      critics = critics.substring(0, prompt) + critics.substring(prompt+1, name.length());
            
        //  }
        //}
        
        PrintWriter output;
        output = createWriter("./data/" + rawname + ".txt"); 
        output.println(name + "\n" + str(year) + "\n" + str(playtime) + "\n" + rating + "\n" + director + "\n" + Sgenre);
        output.close();
      }
    }
    ix = 12+250*((rank-1)%5);
    iy = up+350*(int((rank-1)/5))+page;
  }
  
  void get_boxoffice() {
    String url = "https://www.rottentomatoes.com/m/" + (String)moviename.get((rank+genre_num*100)-1);
    String html = "";
    
    String[] lines = {};
    
    int did = 1;
    while (did == 1) {
      try {
        lines = loadStrings(url);
        html = join(lines, "");
        did = 0;
      } catch (Exception e) {
        did = 1;
      }
    }
    String boxf = giveMeTextBetween(html, "<div class=\"meta-value\">$", "</div>");
    String[] boxxf = split(boxf, ',');
    boxf = join(boxxf, "");
    boxoffice = int(boxf);
  }
  
  int raw_ascore = 0, raw_tscore = 0, raw_amany = 0, raw_tmany = 0;
  void get_score() {
    String url = "https://www.rottentomatoes.com/m/" + (String)moviename.get(rank+g*100-1);
    String html = "";
    
    String[] lines = {};
    
    int did = 1;
    while (did == 1) {
      try {
        lines = loadStrings(url);
        html = join(lines, "");
        did = 0;
      } catch (Exception e) {
        did = 1;
      }
    }
    
    ArrayList score;
    score = new ArrayList();
    for (int i = 0; i<lines.length; i++) {
        String t = giveMeTextBetween(lines[i], "                    ", "%");
        if (t != "")
          score.add(int(t));
        if (score.size() == 3)
          break;
      }
    if (score.size() >=3) {
      tscore = (int)score.get(1);
      ascore = (int)score.get(2);
    }
    else {
      println("Score Error!!!!!!!!\n");
      tscore = 0;
      ascore = 0;
    }
    
    String tmptmp = giveMeTextBetween(html, "<small class=\"mop-ratings-wrap__text--small\">                            ", "                    </small>");
    tmany = int(tmptmp);
    tmptmp = giveMeTextBetween(html, "<strong class=\"mop-ratings-wrap__text--small\">User Ratings: ", "</strong>");
    String[] asdf = split(tmptmp, ",");
    tmptmp = join(asdf, "");
    amany = int(tmptmp);
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //ArrayList many;
    //many = new ArrayList();
    //for (int i = 0; i<lines.length; i++) {
    //  String t = giveMeTextBetween(lines[i], "                    ", "%");
    //}
  }

  
  void display(float x, float y) {
    noStroke();
    image(poster, x+22, y+5+page+page_genre, 206, 305);
    fill(255);
      
    textSize(25);
    textAlign(LEFT);
    text(rank, x+22, y+5+305+5+25+page+page_genre);
    textSize(15);
    if (rank<10) {
      if (name.length() < 20) text(name, x+22+25+10-17+3, y+5+305+10+8+3+page+page_genre);
      else if (rank<100) {
        String[] saray = split(name, " ");
        String l1 = "", l2 = "";
        int the_length = 0;
        int i = 0; 
        for (; i<saray.length && the_length+saray[i].length()<17; i++) {
          l1 = l1 + " " + saray[i];
          the_length += saray[i].length() + 1;
        }
        for (; i<saray.length; i++) l2 = l2 + " " + saray[i];
        text(l1, x+22+25+10-17+3, y+5+305+10+8+3+page+page_genre);
        text(l2, x+22+25+10-17+3, y+5+305+10+8+3+12+page+page_genre);
      }
      else {
        String[] saray = split(name, " ");
        String l1 = "", l2 = "";
        int the_length = 0;
        int i = 0; 
        for (; i<saray.length && the_length+saray[i].length()<17; i++) {
          l1 = l1 + " " + saray[i];
          the_length += saray[i].length() + 1;
        }
        the_length = 0;
        for (; i<saray.length && the_length+saray[i].length()<17; i++) {
          l2 = l2 + " " + saray[i];
          the_length += saray[i].length() + 1;
        }
        l2 = l2 + "...";
        text(l1, x+22+25+10+3, y+5+305+10+8+3+page+page_genre);
        text(l2, x+22+25+10+3, y+5+305+10+8+3+12+page+page_genre);
      }
    }
    else if (rank<100) {
      if (name.length() < 17) text(name, x+22+25+10+3, y+5+305+10+8+3+page+page_genre);
      else if (name.length() < 36){
        String[] saray = split(name, " ");
        String l1 = "", l2 = "";
        int the_length = 0;
        int i = 0; 
        for (; i<saray.length && the_length+saray[i].length()<17; i++) {
          l1 = l1 + " " + saray[i];
          the_length += saray[i].length() + 1;
        }
        for (; i<saray.length; i++) l2 = l2 + " " + saray[i];
        text(l1, x+22+25+10+3, y+5+305+10+8+3+page+page_genre);
        text(l2, x+22+25+10+3, y+5+305+10+8+3+12+page+page_genre);
      }
      else {
        String[] saray = split(name, " ");
        String l1 = "", l2 = "";
        int the_length = 0;
        int i = 0; 
        for (; i<saray.length && the_length+saray[i].length()<17; i++) {
          l1 = l1 + " " + saray[i];
          the_length += saray[i].length();
        }
        the_length = 0;
        for (; i<saray.length && the_length+saray[i].length()<17; i++) {
          l2 = l2 + " " + saray[i];
          the_length += saray[i].length() + 1;
        }
        l2 = l2 + "...";
        text(l1, x+22+25+10+3, y+5+305+10+8+3+page+page_genre);
        text(l2, x+22+25+10+3, y+5+305+10+8+3+12+page+page_genre);
      }
    }
    else {
      if (name.length() < 17) text(name, x+22+25+10+3+17, y+5+305+10+8+3+page+page_genre);
      else if (name.length() < 36){
        String[] saray = split(name, " ");
        String l1 = "", l2 = "";
        int the_length = 0;
        int i = 0; 
        for (; i<saray.length && the_length+saray[i].length()<17; i++) {
          l1 = l1 + " " + saray[i];
          the_length += saray[i].length() + 1;
        }
        for (; i<saray.length; i++) l2 = l2 + " " + saray[i];
        text(l1, x+22+25+10+3+17, y+5+305+10+8+3+page+page_genre);
        text(l2, x+22+25+10+3+17, y+5+305+10+8+3+12+page+page_genre);
      }
      else {
        String[] saray = split(name, " ");
        String l1 = "", l2 = "";
        int the_length = 0;
        int i = 0; 
        for (; i<saray.length && the_length+saray[i].length()<17; i++) {
          l1 = l1 + " " + saray[i];
          the_length += saray[i].length() + 1;
        }
        the_length = 0;
        for (; i<saray.length && the_length+saray[i].length()<17; i++) {
          l2 = l2 + " " + saray[i];
          the_length += saray[i].length() + 1;
        }
        l2 = l2 + "...";
        text(l1, x+22+25+10+3+17, y+5+305+10+8+3+page+page_genre);
        text(l2, x+22+25+10+3+17, y+5+305+10+8+3+12+page+page_genre);
      }
    }
  }
  
  void mouse_in_sub() {
    noStroke();
    if (bigger == 0) return;
    
    float the_size_number = map(bigger, 0, 10, 1, 1.5);
    
    float m_i_number = 0;
    if ((rank-1)%5 == 0) m_i_number = 0;
    else if ((rank-1)%5 == 4) m_i_number = -(206*the_size_number-206);
    else m_i_number = -(206*the_size_number-206)/2;
    
    image(poster, ix+22+m_i_number, iy+5+page-(305*the_size_number-305)/2+page_genre, 206*the_size_number, 305*the_size_number);
    
    
    fill(0, 150);
    setGradient(int(ix+22+m_i_number), int(iy+5+page-(305*the_size_number-305)/2+page_genre), 206*the_size_number, 305*the_size_number, b1, b2, Y_AXIS);
    if (bigger == 10) {
      fill(255);
      textSize(50);
      text(rank, ix+22+m_i_number+10, iy+5+page-(305*the_size_number-305)/2+305*the_size_number/2+page_genre);
      
      //mouse_in_score();
      
      String[] saray = split(name, " ");
      String l1 = "", l2 = "";
      int the_length = 0;
      int i = 0;
      for (; i<saray.length && the_length+saray[i].length()<17; i++) {
        l1 = l1 + " " + saray[i];
        the_length += saray[i].length() + 1;
      }
      for (; i<saray.length && the_length+saray[i].length()<17*2-2; i++) {
        l2 = l2 + " " + saray[i];
        the_length += saray[i].length() + 1;
      }
      if (name.length() >= 17*2-2) l2 = l2 + "...";
    
      textSize(20);
      if (rank <10) {
        fill(255);
        if (name.length() <=17)
          text(name, ix+22+33+m_i_number+10, iy+5+page-(305*the_size_number-305)/2+305*the_size_number/2-22+page_genre);
        else {
          text(l1, ix+22+33+m_i_number+10, iy+5+page-(305*the_size_number-305)/2+305*the_size_number/2-22+page_genre);
          if (l2 != "") text(l2, ix+22+33+m_i_number+10, iy+5+page-(305*the_size_number-305)/2+305*the_size_number/2+page_genre);
        }
      }
      else if (rank <100) {
        fill(255);
        if (name.length() <= 17)
          text(name, ix+22+33*2+m_i_number+10, iy+5+page-(305*the_size_number-305)/2+305*the_size_number/2-22+page_genre);
        else {
          text(l1, ix+22+33*2+m_i_number+10, iy+5+page-(305*the_size_number-305)/2+305*the_size_number/2-22+page_genre);
          if (l2 != "") text(l2, ix+22+33*2+m_i_number+10, iy+5+page-(305*the_size_number-305)/2+305*the_size_number/2+page_genre);
        }
      }
      else {
        fill(255);
        if (name.length() <= 17)
          text(name, ix+22+33*3+m_i_number+10, iy+5+page-(305*the_size_number-305)/2+305*the_size_number/2-22+page_genre);
        else {
          text(l1, ix+22+33*3+m_i_number+10, iy+5+page-(305*the_size_number-305)/2+305*the_size_number/2-22+page_genre);
          if (l2 != "") text(l2, ix+22+33*3+m_i_number+10, iy+5+page-(305*the_size_number-305)/2+305*the_size_number/2+page_genre);
        }
      }
      
      stroke(255);
      line(ix+22+m_i_number+8, iy+5+page-(305*the_size_number-305)/2+305*the_size_number/2+10+page_genre, ix+22+m_i_number+206*1.5-8, iy+5+page-(305*the_size_number-305)/2+305*the_size_number/2+10+page_genre);
      line(ix+22+m_i_number+206*1.5/2, iy+5+page-(305*the_size_number-305)/2+305*the_size_number/2+10+page_genre, ix+22+m_i_number+206*1.5/2, iy+5+page-(305*the_size_number-305)/2+305*the_size_number-15+page_genre);
      
      int isisin = 0;
      if (mouseX >= ix+22+m_i_number+206*1.5/2+10 && mouseX <= ix+22+m_i_number+206*1.5/2+10 + 100 && mouseY >= iy+5+page-(305*the_size_number-305)/2+305*the_size_number/2+10+page_genre+10 && mouseY <= iy+5+page-(305*the_size_number-305)/2+305*the_size_number/2+10+page_genre+10 + 30) isisin = 1;
      else isisin = 0;
      
      if(isisin == 0) stroke(255);
      else stroke(82, 189, 249);
      noFill();
      rect(ix+22+m_i_number+206*1.5/2+10, iy+5+page-(305*the_size_number-305)/2+305*the_size_number/2+10+page_genre+10, 100, 30, 20);
      if(isisin == 1) fill(82, 189, 249);
      else fill(255);
      
      noStroke();
      text("Analyze", ix+22+m_i_number+206*1.5/2+10+10, iy+5+page-(305*the_size_number-305)/2+305*the_size_number/2+10+page_genre+10+20);
      
      textSize(12);
      fill(180);
      text("If you click this button, you can see more information about this movie", ix+22+m_i_number+206*1.5/2+10, iy+5+page-(305*the_size_number-305)/2+305*the_size_number/2+10+page_genre+10+40, 206*1.5/2-40, 305*the_size_number/2-10-40);
      
      if (mouse_over_button_conditions) {
        mouse_over_button_conditions = false;
        if (mouseX >= ix+22+m_i_number+206*1.5/2+10 && mouseX <= ix+22+m_i_number+206*1.5/2+10 + 100 && mouseY >= iy+5+page-(305*the_size_number-305)/2+305*the_size_number/2+10+page_genre+10 && mouseY <= iy+5+page-(305*the_size_number-305)/2+305*the_size_number/2+10+page_genre+10 + 30) {
        
          analyze = rank;
          screen_end = 1;
        }
      }
      
      noStroke();
      fill(225);
      textSize(17);
      text("Year: " + year, ix+22+m_i_number+10, iy+5+page-(305*the_size_number-305)/2+305*the_size_number/2+30+page_genre);
      text("Playtime: " + playtime + "M", ix+22+m_i_number+10, iy+5+page-(305*the_size_number-305)/2+305*the_size_number/2+60+page_genre);
      text("Rating: " + rating, ix+22+m_i_number+10, iy+5+page-(305*the_size_number-305)/2+305*the_size_number/2+90+page_genre);
      if (director.equals("None") == false) {
        text("Director:", ix+22+m_i_number+10, iy+5+page-(305*the_size_number-305)/2+305*the_size_number/2+90+30+page_genre);
        if (director.length() <= 14) text(director, ix+22+m_i_number+10, iy+5+page-(305*the_size_number-305)/2+305*the_size_number/2+90+30*2+page_genre);
        else if (director.length() <= 14*2) {
          String[] fdirector = split(director, " ");
          String ld1 = "", ld2 = "";
          int di = 0, dlong = 0;
          for (; di < fdirector.length && dlong+fdirector[di].length() <= 14; di ++) {
            ld1 = ld1 + fdirector[di] + " ";
            dlong += fdirector[di].length() + 1;
          }
          dlong = 0;
          for (; di < fdirector.length && dlong+fdirector[di].length() <= 14; di ++) {
            ld2 = ld2 + fdirector[di] + " ";
            dlong += fdirector[di].length() + 1;
          }
          text(ld1, ix+22+m_i_number+10, iy+5+page-(305*the_size_number-305)/2+305*the_size_number/2+90+30*2+page_genre);
          text(ld2, ix+22+m_i_number+10, iy+5+page-(305*the_size_number-305)/2+305*the_size_number/2+90+30*3+page_genre);
        }
        else {
          String[] fdirector = split(director, " ");
          String ld1 = "", ld2 = "";
          int di = 0, dlong = 0;
          for (; di < fdirector.length && dlong+fdirector[di].length() <= 14; di ++) {
            ld1 = ld1 + fdirector[di] + " ";
            dlong += fdirector[di].length() + 1;
          }
          dlong = 0;
          for (; di < fdirector.length && dlong+fdirector[di].length() <= 12; di ++) {
            ld2 = ld2 + fdirector[di] + " ";
            dlong += fdirector[di].length() + 1;
          }
          ld2 = ld2 + "...";
          text(ld1, ix+22+m_i_number+10, iy+5+page-(305*the_size_number-305)/2+305*the_size_number/2+90+30*2+page_genre);
          text(ld2, ix+22+m_i_number+10, iy+5+page-(305*the_size_number-305)/2+305*the_size_number/2+90+30*3+page_genre);
        }
      }
    }
  }
  
  int bigger = 0;
  void mouse_in() {
    if (ix + 22 <=mouseX && mouseX <= ix + 22 + 206 && iy + 5 + page+page_genre <= mouseY && mouseY <= iy + 5 + 305 + page+page_genre && mouse_in_button == 0) {
      if (bigger <10) bigger += 2;
      //println(rawname);
      mouse_in_sub();
    }
    else if (bigger >0) {
      bigger -= 2;
      mouse_in_sub();
    }
  }
}

ArrayList analyze_movie;

int analyze = 0;

public void settings() {
  size(1274, 768);
}

PFont font;

boolean mouse_over_button_conditions = false;
void mouseReleased() {
  println("************************");
  mouse_over_button_conditions = true;
}

void setup() {
  font = createFont("Montserrat-Bold.ttf",48);
  textFont(font);
  b1 = color(255);
  b2 = color(0);
  saflix = loadImage("saflix.png");
  audience_best = loadImage("audience_best.png");
  audience_worst = loadImage("audience_worst.png");
  tomato_best = loadImage("tomato_best.png");
  tomato_soso = loadImage("tomato_soso.png");
  tomato_worst = loadImage("tomato_worst.png");
  fmoviename = new ArrayList();
  moviename = new ArrayList();
  more_analyze = new ArrayList();
  analyze_movie = new ArrayList();
  year_hash = new HashMap<Integer,Integer>();
  director_hash = new HashMap<String, Integer>();
  year_tscore_hash = new HashMap<Integer, Integer>();
  year_ascore_hash = new HashMap<Integer, Integer>();
  year_rank_hash = new HashMap<Integer,Integer>();
  year_user_rating_hash = new HashMap<Integer,Integer>();
  year_tomatometer_count_hash = new HashMap<Integer,Integer>();
  //size(1274, 768);
  background(0);
  //fill(255);
  //textSize(100);
  //text("Please wait...", width/2, height/2);
  image(saflix, width/2-197*200/87/2, height/2-140, 197*200/87, 200);
  M_array = new ArrayList();
  //for (int i = 0; i<100; i++)
  //  println(moviename.get(i));
  
  loadData(0);
}

boolean start_loading = false;

int k = 0, the_number = 1;
int screen_end = 0;

void keyPressed() {
  if (keyCode == UP && page <0) {
    page += 5;
  }
  if (keyCode == DOWN && page > -7010+80-up) {
    page -= 5;
  }
}

void draw() {

  
  if (the_number<=amount) {
    add_genre();
    screen_end = 1;
  }
  else {  
    mouse_rank = int((mouseY-page-up)/350)*5 + int((mouseX-12)/250);
    
    //page <=0 && page + t < 0 && page + t > -7010+80-up
    
    if (analyze == 0) show_table_page();
    else {
      analyze_page();
    }
    
    screenChange();
  }
  mouse_over_button_conditions = false;
}

int down_number = 0, more_flag = 0;
ArrayList more_analyze;
void more_analyze_page() {
  boolean diddid = false;
  fill(0);
  rect(0,0,width, height);
  
  Movie p = (Movie)M_array.get(analyze-1);
  
  if (more == 1) {
    if (more_analyze.isEmpty() && more_flag == 0) {
      for (int i = 0; i<100; i++) {
        if (i != analyze-1) {
          if (p.year == ((Movie)M_array.get(i)).year) {
            more_analyze.add((Movie)M_array.get(i));
          }
        }
      }
      down_number = more_analyze.size();
      more_flag = 1;
    }
    for (int i = 0; i<more_analyze.size(); i++) {
      ((Movie) more_analyze.get(i)).display(12+250*((i-1)%5), up+350*(int((i-1)/5))-save_page);
      diddid = true;
    }
    if (diddid == false) {
      textSize(40);
      fill(255);
      text("No matching movies...", 22*3, up+20+page-save_page, 1000, 500);
    }
  }
  else if (more == 2) {
    if (more_analyze.isEmpty() && more_flag == 0) {
      for (int i = 0; i<100; i++) {
        if (i != analyze-1) {
          if (p.director.equals(((Movie)M_array.get(i)).director)) {
            more_analyze.add((Movie)M_array.get(i));
          }
        }
      }
      down_number = more_analyze.size();
      more_flag = 1;
    }
    for (int i = 0; i<more_analyze.size(); i++) {
      ((Movie) more_analyze.get(i)).display(12+250*((i-1)%5), up+350*(int((i-1)/5))-save_page);
      diddid = true;
    }
    if (diddid == false) {
      textSize(40);
      fill(255);
      text("No matching movies...", 22*3, up+20+page-save_page, 1000, 500);
    }
  }
  else if (more == 3) {
    if (more_analyze.isEmpty() && more_flag == 0) {
      for (int i = 0; i<100; i++) {
        if (i != analyze-1) {
          if (p.rating.equals(((Movie)M_array.get(i)).rating)) {
            more_analyze.add((Movie)M_array.get(i));
          }
        }
      }
      down_number = more_analyze.size();
      more_flag = 1;
    }
    for (int i = 0; i<more_analyze.size(); i++) {
      ((Movie) more_analyze.get(i)).display(12+250*((i-1)%5), up+350*(int((i-1)/5))-save_page);
      diddid = true;
    }
    if (diddid == false) {
      textSize(40);
      fill(255);
      text("No matching movies...", 22*3, up+20+page-save_page, 1000, 500);
    }
  }
  
  image(saflix, 40, 10+page-save_page, 197*70/87, 70);
  
  ////////////esc
  stroke(255);
  if (mouseX >= width-60 && mouseX <= width-60+30 && mouseY >= 50 && mouseY <= 80) {
    fill(255);
    if (mouse_over_button_conditions) {
      more_flag = 0;
      save_page = 0;
      more = 0;
      screen_end = 1;
      more_analyze.clear();
      mouse_over_button_conditions = false;
    }
  }
  else noFill();
  rect(width-60, 50, 30, 30);
}

int more = 0;
int save_page = 0;
void analyze_page() {
  fill(0);
  rect(0,0,width, height);
  
  if (more != 0) {
    more_analyze_page();
  }
  else {
    noStroke();
    Movie p = (Movie)M_array.get(analyze-1);
    image(p.poster, 50, 50, 500*206/305, 500);
    fill(255);
    
    if (p.name.length() <= 19) textSize(55);
    else if (p.name.length() <= 19*2) textSize(45);
    else if (p.name.length() <= 19*3) textSize(45);
    else if (p.name.length() <= 19*4) textSize(40);
    else if (p.name.length() <= 19*5) textSize(35);
    else if (p.name.length() <= 19*6) textSize(30);
    else if (p.name.length() <= 19*7) textSize(25);
    
    text(p.name, 50 + 500*206/305 + 50, 50, width - (50 + 500*206/305 + 50)-70, 130);
    noFill();
    stroke(255);
    //rect(50 + 500*206/305 + 50, 50, width - (50 + 500*206/305 + 50)-70, 130);
    
    stroke(255);
    line(438, 182, 1204, 182);
    
    String ag = "";
    for (int i = 0; i<p.Mgenre.length; i++) {
      ag += p.Mgenre[i] + ", ";
    }
    ag = ag.substring(0, ag.length()-2);
    
    textSize(27);
    text("Year : " + str(p.year) + "\n" + "Director : " + p.director + "\n" + "Rating : " + p.rating, 438, 190, 766, 260);
    //270+2+40
    text("Genre : ", 438, 270+2+40, 766-130-10, 260);
    textSize(23);
    text(ag, 438+110, 270+2+40, 766-130-10-110, 260);
    
    if(p.boxoffice == -1) p.get_boxoffice();
    int bo = p.boxoffice;
    textSize(27);
    if (bo != 0) text("BoxOffice : $" + str(bo), 438, 270+2+40+40+40, 766-130-10, 260);
    else text("BoxOffice hasn't been released yet.", 438, 270+2+40+40+40, 766-130-10, 260);
    
    
    textSize(23);
    if (mouseX >= 438+766-130 && mouseX <= 438+766 && mouseY >= 190 && mouseY <= 190 + 35) {
      stroke(82, 189, 249);
      noFill();
      rect(438+766-130, 190, 130, 35, 20);
      fill(82, 189, 249);
      text("More", 438+766-130+37, 190+2, 130, 35);
      
      if (mouse_over_button_conditions) {
        save_page = page;
        more = 1;
        screen_end = 1;
        mouse_over_button_conditions = false;
      }
    } else {
      stroke(255);
      noFill();
      rect(438+766-130, 190, 130, 35, 20);
      fill(255);
      text("More", 438+766-130+37, 190+2, 130, 35);
    }
    if (mouseX >= 438+766-130 && mouseX <= 438+766 && mouseY >= 230 && mouseY <= 230 + 35) {
      stroke(82, 189, 249);
      noFill();
      rect(438+766-130, 230, 130, 35, 20);
      fill(82, 189, 249);
      text("More", 438+766-130+37, 230+2, 130, 35);
      
      if (mouse_over_button_conditions) {
        save_page = page;
        more = 2;
        screen_end = 1;
        mouse_over_button_conditions = false;
      }
    } else {
      stroke(255);
      noFill();
      rect(438+766-130, 230, 130, 35, 20);
      fill(255);
      text("More", 438+766-130+37, 230+2, 130, 35);
    }
    if (mouseX >= 438+766-130 && mouseX <= 438+766 && mouseY >= 270 && mouseY <= 270 + 35) {
      stroke(82, 189, 249);
      noFill();
      rect(438+766-130, 270, 130, 35, 20);
      fill(82, 189, 249);
      text("More", 438+766-130+37, 270+2, 130, 35);
      if (mouse_over_button_conditions) {
        save_page = page;
        more = 3;
        screen_end = 1;
        mouse_over_button_conditions = false;
      }
    } else {
      stroke(255);
      noFill();
      rect(438+766-130, 270, 130, 35, 20);
      fill(255);
      text("More", 438+766-130+37, 270+2, 130, 35);
    }
    //if (mouseX >= 438+766-130 && mouseX <= 438+766 && mouseY >= 270+40 && mouseY <= 270+40 + 35) {
    //  stroke(82, 189, 249);
    //  noFill();
    //  rect(438+766-130, 270+40, 130, 35, 20);
    //  fill(82, 189, 249);
    //  text("More", 438+766-130+37, 270+2+40, 130, 35);
    //  if (mouse_over_button_conditions) {
    //    save_page = page;
    //    more = 4;
    //    screen_end = 1;
    //    mouse_over_button_conditions = false;
    //  }
    //} else {
    //  stroke(255);
    //  noFill();
    //  rect(438+766-130, 270+40, 130, 35, 20);
    //  fill(255);
    //  text("More", 438+766-130+37, 270+2+40, 130, 35);
    //}
    
    //////SCORE
    if (p.ascore == 0) p.get_score();
    if (p.tscore >=75) {
      noStroke();
      fill(255);
      image(tomato_best, 497, 360+40+40+40, 80*tb[0]/tb[1], 80);
      textSize(40);
      text(str(p.tscore)+"%", 622, 360+40+40+40, 174, 100);
    }
    else if (p.tscore >=60) {
      noStroke();
      fill(255);
      image(tomato_soso, 497, 360+40+40+40, 80*ts[0]/ts[1], 80);
      textSize(40);
      text(str(p.tscore)+"%", 622, 360+40+40+40, 174, 100);
    }
    else {
      noStroke();
      fill(255);
      image(tomato_worst, 497, 360+40+40+40, 80*tw[0]/tw[1], 80);
      textSize(40);
      text(str(p.tscore)+"%", 622, 360+40+40+40, 174, 100);
    }
    
    if (p.ascore >= 60) {
      noStroke();
      fill(255);
      image(audience_best, 852, 360+40+40+40, 80*ab[0]/ab[1], 80);
      textSize(40);
      text(str(p.ascore)+"%", 972, 360+40+40+40, 174, 100);
    }
    else {
      noStroke();
      fill(255);
      image(audience_worst, 852, 360+40+40+40, 80*aw[0]/aw[1], 80);
      textSize(40);
      text(str(p.ascore)+"%", 972, 360+40+40+40, 174, 100);
    }
    textSize(18);
    text("TOMATOMETER", 622, 429-10+40+40+40, 174, 32);
    text("AUDIENCE SCORE", 972, 429-10+40+40+40, 174, 32);
    
    fill(200);
    textSize(18);
    text("Total Count: " + str(p.tmany), 497+50, 465+40+40+40, 300 ,32);
    text("User Ratings: " + str(p.amany), 852+50, 465+40+40+40, 300, 32);
    
    int isin = 0;
    if (mouseX >= 50 && mouseX <= 50 + 338 && mouseY >= 601 && mouseY <= 601 + 70) {
      isin = 1;
      if(mouse_over_button_conditions) {
        link(p.murl);
        mouse_over_button_conditions = false;
      }
    }
    else isin = 0;
    
    noFill();
    if(isin == 0) stroke(255);
    else stroke(82, 189, 249);
    textSize(20);
    rect(50, 608, 338, 70-10, 20);
    if(isin == 0) fill(255); 
    else fill(82, 189, 249);
    text("       Rotten Tomato Page", 78, 624, 281, 60);
    
    stroke(255);
    if (mouseX >= width-60 && mouseX <= width-60+30 && mouseY >= 50 && mouseY <= 80) {
      fill(255);
      if (mouse_over_button_conditions) {
        analyze = 0;
        screen_end = 1;
        mouse_over_button_conditions = false;
      }
    }
    else noFill();
    rect(width-60, 50, 30, 30);
  }
}

void show_table_page() {
  if (mouse_button_clicked == false) {
    fill(0);
    rect(0,0,width, height);
    
    stroke(255);
    line(22, up-10+page, width-22, up-10+page);
    line(22, up-10+page+page_genre, width-22, up-10+page+page_genre);
    noStroke();
    image(saflix, 40, 10+page, 197*70/87, 70);
    for (int i = genre_num*100; i<genre_num*100+100; i++) {
      Movie p = (Movie) M_array.get(i);
      p.display(p.ix, p.iy);
    }
    
    //genre_button();
    
    for (int i = 0; i<100; i++) {
      Movie p = (Movie) M_array.get(i+genre_num*100);
      p.mouse_in();
    }
    //Movie p = (Movie) M_array.get(mouse_rank+genre_num*100);
    //p.mouse_in();
    plus_button();
  }
  else plus_button_click();
}

int on_the_genre_button = 0;  // choosing?
int genre_mouse_click = 0;    // did mouse clicked?

int box_w = 200;
void genre_button() {
  if (mouseX >= width - 40 - box_w && mouseX <= width - 40 - box_w+box_w && mouseY >= 10+page+5 && mouseY <= 10 + page + 60+5) {
    stroke(255);
    fill(100);
    rect(width - 40 - box_w, 10+page+5, box_w, 60, 10);
    fill(255);
    textSize(30);
    text("Genre", width - 40 - box_w + 50, 10+page+15, 300, 70);
    noFill();
    //triangle(width - 40 - 300 + 100+120, 10+page+20, width - 40 - 300 + 100+120+30, 10+page+20, width - 40 - 300 + 100+120+15, 10+page+20+20);
    noStroke();
    if (mouse_over_button_conditions) {
      genre_mouse_click = 1;
      mouse_over_button_conditions = false;
    }
  }
  else {
    stroke(255);
    noFill();
    rect(width - 40 - box_w, 10+page+5, box_w, 60, 10);
    fill(255);
    textSize(30);
    text("Genre", width - 40 - box_w + 50, 10+page+15, 300, 70);
    noFill();
    //triangle(width - 40 - 300 + 100+120, 10+page+20, width - 40 - 300 + 100+120+30, 10+page+20, width - 40 - 300 + 100+120+15, 10+page+20+20);
    noStroke();
    if (mouse_over_button_conditions) {
      mouse_over_button_conditions = false;
      if (mouseY <= up-10+page || mouseY >= up-10+page+page_genre) {
        genre_mouse_click = 0;
      }
    }
  }
  show_genre();
}

int page_genre = 0;
int page_genre_top = 240;
void show_genre() {
  if (genre_mouse_click == 1) {
    if (page_genre < page_genre_top) page_genre += 20;
  }
  else if (page_genre > 0) page_genre -= 20;
  
  if (genre_mouse_click == 1 && page_genre == page_genre_top) {
    for (int i = 0; i<5; i++) {
      for (int j = 0; j<4; j++) {
        fill(255);
        textSize(20);
        if (mouseX >= 22 + 246*i && mouseX <= 22 + 246*i + 246 && mouseY >= up + 50*j + page + 40-30 && mouseY <= up + 50*j + page + 40-30 + 50) {
          fill(82, 189, 249);
        }
        if (i+j*5 < 18) {
          if (genre[i+j*5].length() <= 20) {
            text(genre[i+j*5], 22+ 246*i +10, up + 50 * j + page + 40);
          }
          else {
            int hru = 0;
            int hru_length = 0;
            String[] gg = split(genre[i+j*5], " ");
            String hru_l1 = "";
            String hru_l2 = "";
            for(; hru < gg.length && hru_length + gg[hru].length()+1 <= 20; hru++) {
              hru_l1 += gg[hru] + " ";
              hru_length += gg[hru].length() + 1;
            }
            hru_length = 0;
            for (; hru< gg.length && hru_length + gg[hru].length() +1 <= 20; hru++) {
              hru_l2 += gg[hru] + " ";
              hru_length += gg[hru].length() + 1;
            }
            text(hru_l1, 22+ 246*i +10, up + 50 * j + page + 30);
            text(hru_l2, 22+ 246*i +10, up + 50 * j + page + 55);
          }
          noFill();
          stroke(255);
          //rect(22 + 246*i, up + 50*j + page + 40-30, 246, 50);
          
          if (mouse_over_button_conditions) {
            mouse_over_button_conditions = false;
            if (mouseX >= 22 + 246*i && mouseX <= 22 + 246*i + 246 && mouseY >= up + 50*j + page + 40-30 && mouseY <= up + 50*j + page + 40-30 + 50) {
              genre_num = i+j*5;
              //println(genre_num);
              //println(genre[genre_num]);
              screen_end = 1;
            }
          }
        }
      }
    }
  }
}

color[] genre_color = {color(131, 32, 34), color(156, 40, 41), color(174, 43, 47), color(194, 45, 45), color(222, 58, 55), color(228, 77, 73), color(237, 95, 89), color(239, 130, 127), color(245, 189, 187)};

void genre_chart_stick(float r, float x, float y, int[] data, String[] text_data) {
  image(saflix, 40, 10, 197*70/87, 70);
  float lastwid = 0;
  for (int i = 1; i < data.length-1; i++) {
    float wid = map(data[i], 0, all_genre_num, 0, width-200);
    float rrr = 0;
    float bbb = 0;
    float ggg = 0;
    if (i%3 == 0) {
      rrr = map(i, 0, data.length, 150, 255);
      ggg = map(i, 0, data.length, 150, 255)/3;
    }
    else if (i%3 == 1) {
      rrr = map(i, 0, data.length, 150, 255);
      bbb = map(i, 0, data.length, 150, 255)/3;
    }
    else {
      rrr = map(i, 0, data.length, 150, 255);
      bbb = map(i, 0, data.length, 150, 255)/3;
      ggg = map(i, 0, data.length, 150, 255)/3;
    }
    
    fill(rrr, ggg, bbb);
    rect(100 + lastwid, height/2-30, wid, 60);
    
    lastwid += wid;
  }
  lastwid = 0;
  for (int i = 1; i < data.length-1; i++) {
    float wid = map(data[i], 0, all_genre_num, 0, width-200);

    if(mouseX >= lastwid+100 && mouseX < lastwid+wid+100 && mouseY >= height/2-30 && mouseY <= height/2 + 30) {
      textSize(20);
      fill(255);
      float frufru = int(float(data[i])/float(all_genre_num)*10000);
      frufru = frufru/100;
      text(text_data[i] + "\n" + str(data[i]) + " | " + str(frufru) + "%", mouseX-70, mouseY+20, 200,300);
    }
    
    lastwid += wid;
  }
}

/////code here
void chart_pie(int x, int y, int r, int[] data, int max, int start, int end, String[] data_text, color[] data_color) {
  ///0 data.length-1
  float lastAngle = 0;
  for (int k = start; k<end; k++) {
    float angle = map(data[k], 0, max, 0, TWO_PI);
    fill(data_color[k%genre_color.length]);
    noStroke();
    arc(x, y, 2*r, 2*r, lastAngle, lastAngle+angle, PIE);
    lastAngle += angle;
  }
  
  float lll = mouseX - x;
  float hhh = mouseY - y;
  float ddd = sqrt(lll*lll + hhh*hhh);
  float theta = acos(lll/ddd);
  
  if (hhh < 0) theta = TWO_PI - theta;
  
  lastAngle = 0;
  for (int k = 1; k<data.length-1; k++) {
    float angle = map(data[k], 0, max, 0, TWO_PI);
    if (lastAngle <= theta && theta < lastAngle + angle && ddd <= r) {
      float frufru = int(float(data[k])/float(max)*10000);
      frufru = frufru/100;
      
      fill(180);
      stroke(255);
      rect(mouseX, mouseY, 220, 110, 10);
      
      noStroke();
      fill(255);
      textSize(20);
      textAlign(RIGHT, TOP);
      text(data_text[k]+"\n"+str(data[k])+" | "+str(frufru)+"%",  mouseX+10, mouseY+10, 200,90);
      textAlign(RIGHT);
    }
    lastAngle += angle;
  }
}

int all_director_num = 0;
int director_num = 0;
HashMap<String,Integer> director_hash;
boolean director_check = false;

void director_analyze() {
  for (int i = 0; i<100; i++) {
    Movie p = (Movie)M_array.get(i);
    if (director_hash.containsKey(p.director)) {
      int qwert = director_hash.get(p.director);
      director_hash.replace(p.director, qwert + 1);
    }
    else {
      director_num += 1;
      director_hash.put(p.director, 1);
    }
    
    all_director_num += 1;
  }
  director_check = true;
}

void director_pie(int x, int y, int r) {
  ///0 data.length-1
  float lastAngle = 0;
  int qwer = 0;
  
  for(String director_key : director_hash.keySet()) {
    float angle = map(director_hash.get(director_key), 0, all_director_num, 0, TWO_PI);
    fill(genre_color[qwer%genre_color.length]);
    qwer += 1;
    noStroke();
    arc(x, y, 2*r, 2*r, lastAngle, lastAngle+angle, PIE);
    lastAngle += angle;
  }
  
  float lll = mouseX - x;
  float hhh = mouseY - y;
  float ddd = sqrt(lll*lll + hhh*hhh);
  float theta = acos(lll/ddd);
  
  if (hhh < 0) theta = TWO_PI - theta;
  
  lastAngle = 0;
  for(String director_key : director_hash.keySet()) {
    float angle = map(director_hash.get(director_key), 0, all_director_num, 0, TWO_PI);
    if (angle != 0 && lastAngle <= theta && theta < lastAngle + angle && ddd <= r) {
      float frufru = int(float(director_hash.get(director_key))/float(all_year_num)*10000);
      frufru = frufru/100;
      
      fill(180);
      stroke(255);
      rect(mouseX, mouseY, 220, 140, 10);
 
      noStroke();
      fill(255);
      textSize(20);
      textAlign(RIGHT, TOP);
      text("Director : " + "\n" + director_key +"\n"+str(director_hash.get(director_key))+" | "+str(frufru)+"%",  mouseX+10, mouseY+10, 200,120);
      textAlign(RIGHT);
    }
    lastAngle += angle;
  }
}


void year_pie(int x, int y, int r) {
  ///0 data.length-1
  float lastAngle = 0;
  int qwer = 0;
  
  for(int i = year_min; i<=year_max; i++) {
    if (year_hash.containsKey(i)) {
      float angle = map(year_hash.get(i), 0, all_year_num, 0, TWO_PI);
      fill(genre_color[qwer%genre_color.length]);
      qwer += 1;
      noStroke();
      arc(x, y, 2*r, 2*r, lastAngle, lastAngle+angle);
      lastAngle += angle;
    }
  }
  
  float lll = mouseX - x;
  float hhh = mouseY - y;
  float ddd = sqrt(lll*lll + hhh*hhh);
  float theta = acos(lll/ddd);
  
  if (hhh < 0) theta = TWO_PI - theta;
  
  lastAngle = 0;
  for(int i = year_min; i<=year_max; i++) {
    if (year_hash.containsKey(i)) {
      float angle = map(year_hash.get(i), 0, all_year_num, 0, TWO_PI);
      if (angle != 0 && lastAngle <= theta && theta < lastAngle + angle && ddd <= r) {
        float frufru = int(float(year_hash.get(i))/float(all_year_num)*10000);
        frufru = frufru/100;
        
        fill(180);
        stroke(255);
        rect(mouseX, mouseY, 220, 110, 10);
   
        noStroke();
        fill(255);
        textSize(20);
        textAlign(RIGHT, TOP);
        text("Year : " + str(i)+"\n"+str(year_hash.get(i))+" | "+str(frufru)+"%",  mouseX+10, mouseY+10, 200,90);
        textAlign(RIGHT);
      }
      lastAngle += angle;
    }
  }
}


int all_year_num = 0;
int year_min = 9999;
int year_max = 0;
int year_num = 0;
HashMap<Integer,Integer> year_hash;
HashMap<Integer,Integer> year_tscore_hash;
HashMap<Integer,Integer> year_ascore_hash;
HashMap<Integer,Integer> year_rank_hash;
HashMap<Integer,Integer> year_user_rating_hash;
HashMap<Integer,Integer> year_tomatometer_count_hash;
boolean year_check = false;
int year_last = 0;

void year_analyze() {
  for (int i = 0; i<100; i++) {
    Movie p = (Movie)M_array.get(i);
    if (year_min > p.year) year_min = p.year;
    if (year_max < p.year) year_max = p.year;
    if (year_hash.containsKey(p.year)) {
      int qwert = year_hash.get(p.year);
      year_hash.replace(p.year, qwert +1);
    }
    else {
      year_num += 1;
      year_hash.put(p.year, 1);
    }
    
    if (year_tscore_hash.containsKey(p.year)) {
      int qwert = year_tscore_hash.get(p.year);
      int werty = year_ascore_hash.get(p.year);
      int qqqq = year_rank_hash.get(p.year);
      year_tscore_hash.replace(p.year, qwert+p.tscore);
      year_ascore_hash.replace(p.year, werty+p.ascore);
      year_rank_hash.replace(p.year, qqqq+p.rank);
    }
    else {
      year_tscore_hash.put(p.year, p.tscore);
      year_ascore_hash.put(p.year, p.ascore);
      year_rank_hash.put(p.year, p.rank);
    }
    
    all_year_num += 1;
  }
  
  for (int i =0; i<100; i++) {
    Movie p = (Movie)M_array.get(i);
    if (year_last<p.year && p.year != year_max) year_last = p.year;
  }
  year_check = true;
}


int all_genre_num = 0;
int[] genre_many = {all_genre_num, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, all_genre_num};
float[] genre_rank = {all_genre_num, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, all_genre_num};
float[] genre_user_rating = {all_genre_num, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, all_genre_num};
float[] genre_tomatometer_count = {all_genre_num, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, all_genre_num};
float[] genre_user_score = {all_genre_num, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, all_genre_num};
float[] genre_tomato_score = {all_genre_num, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, all_genre_num};
//////////////////all, genre....
void genre_analyze() {
  for (int i = 0; i<100; i++) {
    Movie p = (Movie)M_array.get(i);
    for (int j = 0; j<p.Mgenre.length; j++) {
      for (int qwe = 1; qwe <18; qwe++) {
        if (p.Mgenre[j].equals(genre[qwe])) {
          all_genre_num += 1;
          genre_many[qwe]+= 1;
          genre_rank[qwe]+= p.rank;
          genre_user_score[qwe]+=p.ascore;
          genre_tomato_score[qwe]+=p.tscore;
          println(p.Mgenre[j]);
        }
      }
    }
  }
  genre_many[0] = all_genre_num;
  genre_many[genre_many.length-1] = all_genre_num;
  genre_many_check = true;
  
  for (int i = 1; i<18; i++) {
    if (genre_many[i] != 0) {
      genre_rank[i] = genre_rank[i]/float(genre_many[i]);
      genre_user_score[i] /= float(genre_many[i]);
      genre_tomato_score[i] /= float(genre_many[i]);
    }
    else {
      genre_rank[i] = 0;
      genre_user_score[i] =0;
      genre_tomato_score[i] =0;
    }
  }
}
boolean genre_many_check = false;
boolean all_analyze = false;
String pie_mode = "None";

void all_analyze_page() {
  ///////heretocode
  
  fill(0);
  rect(0,0,width,height);
  image(saflix, 40, 10, 197*70/87, 70);
    
  if (mode.equals("pie")) {
    
    textAlign(CENTER, CENTER);
    textSize(25);
    
    if (mouseX >= 79 && mouseX <= 79 + 207 && mouseY >= 238 && mouseY <= 238 + 70) {
      stroke(82, 189, 249);
      rect(79, 238, 207, 70, 10);
      fill(82, 189, 249);
      text("Genre", 79, 238, 207, 70);
      noFill();
      if (mouse_over_button_conditions && pie_mode.equals("genre") == false) {
        mouse_over_button_conditions = false;
        pie_mode = "genre";
      }
      else if (mouse_over_button_conditions && pie_mode.equals("genre")){
        pie_mode = "None";
      }
    }
    else {
      stroke(255);
      rect(79, 238, 207, 70, 10);
      fill(255);
      text("Genre", 79, 238, 207, 70);
      noFill();
    }
    
    if (mouseX >= 79 && mouseX <= 79 + 207 && mouseY >= 349 && mouseY <= 349 + 70) {
      stroke(82, 189, 249);
      rect(79, 349, 207, 70, 10);
      fill(82, 189, 249);
      text("Year", 79, 349, 207, 70);
      noFill();
      if (mouse_over_button_conditions && pie_mode.equals("year") == false) {
        mouse_over_button_conditions = false;
        pie_mode = "year";
      }
      else if (mouse_over_button_conditions && pie_mode.equals("year")){
        pie_mode = "None";
      }
    }
    else {
      stroke(255);
      rect(79, 349, 207, 70, 10);
      fill(255);
      text("Year", 79, 349, 207, 70);
      noFill();
    }
    
    if (mouseX >= 79 && mouseX <= 79 + 207 && mouseY >= 460 && mouseY <= 460 + 70) {
      stroke(82, 189, 249);
      rect(79, 460, 207, 70, 10);
      fill(82, 189, 249);
      text("Director", 79, 460, 207, 70);
      noFill();
      if (mouse_over_button_conditions && pie_mode.equals("director") == false) {
        mouse_over_button_conditions = false;
        pie_mode = "director";
      }
      else if (mouse_over_button_conditions && pie_mode.equals("director")){
        pie_mode = "None";
      }
    }
    else {
      stroke(255);
      rect(79, 460, 207, 70, 10);
      fill(255);
      text("Director", 79, 460, 207, 70);
      noFill();
    }
    textAlign(LEFT);
    
    if(pie_mode.equals("None")) {
      fill(200);
      ellipse(width/2, height/2, 500, 500);
    }
    
    else if (pie_mode.equals("genre")) {
      if (genre_many_check == false) {
        genre_analyze();
        println("NOW CHECKING");
      }
      if (genre_many_check == true) {
        chart_pie(width/2, height/2, 250, genre_many, all_genre_num, 1, genre_many.length-1, genre, genre_color);
      }
    }
    
    
    else if (pie_mode.equals("year")) {
      ////code here
      if (year_check == false) {
        year_analyze();
      }
      if (year_check) {
        //doit agin
        year_pie(width/2, height/2, 250);
      }
    }
    
    else if (pie_mode.equals("director")) {
      /////code here
      if (director_check == false) {
        director_analyze();
      }
      if (director_check) {
        //doit agin
        director_pie(width/2, height/2, 250);
      }
    }
  }
  
  else if (mode.equals("Graph")) {
    //////now coding
    basic_chart();
    show_chart();
  }
  
  //////esc
  stroke(255);
  if (mouseX >= width-60 && mouseX <= width-60+30 && mouseY >= 50 && mouseY <= 80) {
    fill(255);
    if (mouse_over_button_conditions) {
      save_page = 0;
      screen_end = 1;
      all_analyze = false;
      pie_mode = "None";
      mode = "None";
      x_axis = "None";
      y_axis = "None";
    }
  }
  else noFill();
  rect(width-60, 50, 30, 30);
}

float tomato_score_max = 0;
float tomato_score_min = 123456789;
float audience_score_max = 0;
float audience_score_min = 123456789;
boolean score_chk = false;
void score_analyze() {
  for (int i =0; i<100; i++) {
    Movie p = (Movie)M_array.get(i);
    if (tomato_score_max <= p.tscore) tomato_score_max = p.tscore;
    if (tomato_score_min >= p.tscore) tomato_score_min = p.tscore;
    if (audience_score_max <= p.ascore) audience_score_max = p.ascore;
    if (audience_score_max >= p.ascore) audience_score_min = p.ascore;
  }
  score_chk = true;
}

int x_chk = -1;
int y_chk = -1;
String x_axis = "None";
String y_axis = "None";
String graph_mode = "Line";

boolean graph_chk = false;
boolean year_tomato_chk = false;
float year_tomato_min = 12345678.0;
float year_tomato_max = 0.0;
boolean year_audience_chk = false;
float year_audience_min = 12345678.0;
float year_audience_max = 0.0;
boolean year_rating_chk = false;
float year_rating_min = 12345678.0;
float year_rating_max = 0.0;

void show_chart() {
  if (year_check == false) year_analyze();
  if (genre_many_check == false) genre_analyze();
  if (score_chk == false) score_analyze();
  
  if (x_axis.equals("Year")) {
    if (y_axis.equals("Tomato Score")) {
      float year_xt_one = -1;
      float year_yt_one = -1;
      float year_tscore_last = 0;
      float year_tscore = 0;
      float year_xt_two;
      float year_yt_two;
      
      if (year_tomato_chk == false){
        for (int i = year_min; i<= year_max; i++) {
          if (year_hash.containsKey(i)) {
            year_tscore = float(year_tscore_hash.get(i)) / float(year_hash.get(i));
            if (year_tomato_min > year_tscore) year_tomato_min = year_tscore;
            if (year_tomato_max < year_tscore) year_tomato_max = year_tscore;
          }
        }
        year_tomato_chk = true;
      }
      
      fill(255);
      textSize(20);
      if (str(year_tomato_max).length() >= 4) text(str(year_tomato_max).substring(0,4), 295, 113, 100, 100);
      else text(str(year_tomato_max), 295, 113, 100, 100);
      if (str(year_tomato_min).length() >= 4) text(str(year_tomato_min).substring(0,4), 295, 583, 100, 100);
      else text(str(year_tomato_min), 295, 583, 100, 100);
      text(str(year_max), 1150, 637, 100, 100);
      text(str(year_min), 355, 636, 100, 100);
      
      for (int i = year_min; i<=year_max; i++) {
        if (year_hash.containsKey(i)) {
          year_tscore = float(year_tscore_hash.get(i)) / float(year_hash.get(i));
          year_xt_two = map(i, year_min, year_max, 342+10, 1196-10);
          year_yt_two = map(year_tscore, year_tomato_min, year_tomato_max, 10, 630-103+10);
          year_yt_two = 630 - year_yt_two;
          
          if (year_xt_one == -1) {
            year_tscore_last = year_tscore;
            year_xt_one = year_xt_two;
            year_yt_one = year_yt_two;
          }
          else {
            stroke(255);
            strokeWeight(2);
            line(year_xt_one, year_yt_one, year_xt_two, year_yt_two);
            fill(255);
            ellipse(year_xt_one, year_yt_one, 8, 8);
            ellipse(year_xt_two, year_yt_two, 8, 8);
            
            //if (mouseX >= year_xt_one-4 && mouseX <= year_xt_one+4 && mouseY >= year_yt_one-4 && mouseY <= year_xt_one+4) {
            //  text(str(year_tscore_last), mouseX +10, mouseY +10);
            //}
            //if (mouseX >= year_xt_two-4 && mouseX <= year_xt_two+4 && mouseY >= year_yt_two-4 && mouseY <= year_xt_two+4) {
            //  text(str(year_tscore), mouseX +10, mouseY +10);
            //}
            
            year_tscore_last = year_tscore;
            year_xt_one = year_xt_two;
            year_yt_one = year_yt_two;
          }
        }
      }
    }
      
    if (y_axis.equals("User Score")) {
      float year_xa_one = -1;
      float year_ya_one = -1;
      float year_ascore_last = 0;
      float year_ascore = 0;
      float year_xa_two;
      float year_ya_two;
      
      if (year_audience_chk == false){
        for (int i = year_min; i<= year_max; i++) {
          if (year_hash.containsKey(i)) {
            year_ascore = float(year_ascore_hash.get(i)) / float(year_hash.get(i));
            if (year_audience_min > year_ascore) year_audience_min = year_ascore;
            if (year_audience_max < year_ascore) year_audience_max = year_ascore;
          }
        }
        year_audience_chk = true;
      }
      textSize(20);
      fill(255);
      if (str(year_audience_max).length() >= 4) text(str(year_audience_max).substring(0,4), 295, 113, 100, 100);
      else text(str(year_audience_max), 295, 113, 100, 100);
      if (str(year_audience_min).length() >= 4) text(str(year_audience_min).substring(0,4), 295, 583, 100, 100);
      else text(str(year_audience_min), 295, 583, 100, 100);
      text(str(year_max), 1150, 637, 100, 100);
      text(str(year_min), 355, 636, 100, 100);
      
      for (int i = year_min; i<=year_max; i++) {
        if (year_hash.containsKey(i)) {
          year_ascore = float(year_ascore_hash.get(i)) / float(year_hash.get(i));
          year_xa_two = map(i, year_min, year_max, 342+10, 1196-10);
          year_ya_two = map(year_ascore, year_audience_min, year_audience_max, 10, 630-103+10);
          year_ya_two = 630 - year_ya_two;
          
          if (year_xa_one == -1) {
            year_ascore_last = year_ascore;
            year_xa_one = year_xa_two;
            year_ya_one = year_ya_two;
          }
          else {
            stroke(255);
            strokeWeight(2);
            line(year_xa_one, year_ya_one, year_xa_two, year_ya_two);
            fill(255);
            ellipse(year_xa_one, year_ya_one, 8, 8);
            ellipse(year_xa_two, year_ya_two, 8, 8);
            
            //if (mouseX >= year_xa_one-4 && mouseX <= year_xa_one+4 && mouseY >= year_ya_one-4 && mouseY <= year_xa_one+4) {
            //  text(str(year_ascore_last), mouseX +10, mouseY +10);
            //}
            //if (mouseX >= year_xa_two-4 && mouseX <= year_xa_two+4 && mouseY >= year_ya_two-4 && mouseY <= year_xa_two+4) {
            //  text(str(year_ascore), mouseX +10, mouseY +10);
            //}
            
            year_ascore_last = year_ascore;
            year_xa_one = year_xa_two;
            year_ya_one = year_ya_two;
          }
        }
      }
    }
    
    if (y_axis.equals("Rank")) {
      float year_xr_one = -1;
      float year_yr_one = -1;
      float year_rank_one = -1;
      float year_xr_two;
      float year_yr_two;
      float year_rank_two = -1;
      
      fill(255);
      textSize(20);
      text(str(1), 295, 113, 100, 100);
      text(str(100), 295, 583, 100, 100);
      text(str(year_max), 1150, 637, 100, 100);
      text(str(year_min), 355, 636, 100, 100);
      
      for (int i = year_min; i<=year_max; i++) {
        if (year_hash.containsKey(i)) {
          year_rank_two = float(year_rank_hash.get(i))/float(year_hash.get(i));
          year_xr_two = map(i, year_min, year_max, 342+10, 1196-10);
          year_yr_two = map(year_rank_two, 1, 100, 10, 630-103+10);
          year_yr_two = 630 - year_yr_two;
          
          if (year_xr_one == -1) {
            year_rank_one = year_rank_two;
            year_xr_one = year_xr_two;
            year_yr_one = year_yr_two;
          }
          else {
            stroke(255);
            strokeWeight(2);
            line(year_xr_one, year_yr_one, year_xr_two, year_yr_two);
            fill(255);
            ellipse(year_xr_one, year_yr_one, 8, 8);
            ellipse(year_xr_two, year_yr_two, 8, 8);
            
            //if (mouseX >= year_xr_one-4 && mouseX <= year_xr_one+4 && mouseY >= year_yr_one-4 && mouseY <= year_xr_one+4) {
            //  text(str(year_rank_one), mouseX +10, mouseY +10);
            //}
            //if (mouseX >= year_xr_two-4 && mouseX <= year_xr_two+4 && mouseY >= year_yr_two-4 && mouseY <= year_xr_two+4) {
            //  text(str(year_rank_two), mouseX +10, mouseY +10);
            //}
            
            year_rank_one = year_rank_two;
            year_xr_one = year_xr_two;
            year_yr_one = year_yr_two;
          }
        }
      }
    }
  }
  ////here to codenbnjjo
  
  if (x_axis.equals("Genre")) {
    if (y_axis.equals("Tomato Score")) {

      if (genre_tomato_chk == false) {
        for (int i = 1; i<genre_many.length-1; i++) {
          if (genre_tomato_min > genre_tomato_score[i]) genre_tomato_min = genre_tomato_score[i];
          if (genre_tomato_max < genre_tomato_score[i]) genre_tomato_max = genre_tomato_score[i];
        }
        genre_tomato_chk = true;
      }
      
      fill(255);
      textSize(20);
      if (str(genre_tomato_max).length() >= 4) text(str(genre_tomato_max).substring(0,4), 295, 113, 100, 100);
      else text(str(genre_tomato_max), 295, 113, 100, 100);
      if (str(genre_tomato_min).length() >= 4) text(str(genre_tomato_min).substring(0,4), 295, 583, 100, 100);
      else text(str(genre_tomato_min), 295, 583, 100, 100);
      textSize(15);
      for (int i = 1; i<genre.length; i++) {
        text(genre[i].substring(0, 3), 355+(1150-355)/17*(i-1), 650);
      }
      
      for (int i = 1; i<genre_many.length-2; i++) {
        float xt1 = 355+(1150-355)/17*(i-1);
        float yt1 = 630 - map(genre_tomato_score[i], genre_tomato_min, genre_tomato_max, 10, 630-103+10);
        float xt2 = 355+(1150-355)/17*(i);
        float yt2 = 630 - map(genre_tomato_score[i+1], genre_tomato_min, genre_tomato_max, 10, 630-103+10);
        stroke(255);
        strokeWeight(2);
        line(xt1, yt1, xt2, yt2);
        fill(255);
        ellipse(xt1, yt1, 8, 8);
        ellipse(xt2, yt2, 8, 8);
      }
    }
    if (y_axis.equals("User Score")) {
      if (genre_user_chk == false) {
        for (int i = 1; i<genre_many.length-1; i++) {
          if (genre_user_min > genre_user_score[i]) genre_user_min = genre_user_score[i];
          if (genre_user_max < genre_user_score[i]) genre_user_max = genre_user_score[i];
        }
        genre_user_chk = true;
      }
      fill(255);
      textSize(20);
      if (str(genre_user_max).length() >=4) text(str(genre_user_max).substring(0,4), 295, 113, 100, 100);
      else text(str(genre_user_max), 295, 113, 100, 100);
      if (str(genre_user_min).length() >= 4) text(str(genre_user_min).substring(0,4), 295, 583, 100, 100);
      else text(str(genre_user_min), 295, 583, 100, 100);
      textSize(15);
      for (int i = 1; i<genre.length; i++) {
        text(genre[i].substring(0, 3), 355+(1150-355)/17*(i-1), 650);
      }
      for (int i = 1; i<genre_many.length-2; i++) {
        float xt1 = 355+(1150-355)/17*(i-1);
        float yt1 = 630 - map(genre_user_score[i], genre_user_min, genre_user_max, 10, 630-103+10);
        float xt2 = 355+(1150-355)/17*(i);
        float yt2 = 630 - map(genre_user_score[i+1], genre_user_min, genre_user_max, 10, 630-103+10);
        stroke(255);
        strokeWeight(2);
        line(xt1, yt1, xt2, yt2);
        fill(255);
        ellipse(xt1, yt1, 8, 8);
        ellipse(xt2, yt2, 8, 8);
      }
    }
    if (y_axis.equals("Rank")){
      fill(255);
      textSize(20);
      text(str(1), 295, 113, 100, 100);
      text(str(100), 295, 583, 100, 100);
      textSize(15);
      for (int i = 1; i<genre.length; i++) {
        text(genre[i].substring(0, 3), 355+(1150-355)/17*(i-1), 650);
      }
      for (int i = 1; i<genre_many.length-2; i++) {
        float xt1 = 355+(1150-355)/17*(i-1);
        float yt1 = 630 - map(genre_rank[i], 1, 100, 10, 630-103+10);
        float xt2 = 355+(1150-355)/17*(i);
        float yt2 = 630 - map(genre_rank[i+1], 1, 100, 10, 630-103+10);
        stroke(255);
        strokeWeight(2);
        line(xt1, yt1, xt2, yt2);
        fill(255);
        ellipse(xt1, yt1, 8, 8);
        ellipse(xt2, yt2, 8, 8);
      }
      
    }
  }
  
}

float genre_tomato_min = 12345678;
float genre_tomato_max = 0;
float genre_user_min = 12345678;
float genre_user_max = 0;
boolean genre_tomato_chk = false;
boolean genre_user_chk = false;


String[] xaxis = {"Year", "Genre"};
String[] yaxis = {"Tomato Score", "User Score", "Rank"};
void basic_chart() {
  stroke(255);
  strokeWeight(2);
  textSize(22);
  
  //y axis
  line(342, 630, 342, 103);
  //x axis
  line(342, 630, 1196, 630);
  
  int[] ax_x_b = {635, 781};
  int[] ax_y_b = {676, 676};
  int[] ay_x_b = {61, 61, 61};
  int[] ay_y_b = {297, 367, 437};
  int l_b = 34;
  
  textAlign(LEFT);
  // y select box
  strokeWeight(1);
  noFill();
  rect(61, 297, 34, 34);
  rect(61, 367, 34, 34);
  rect(61, 437, 34, 34);
  noStroke();
  fill(255);
  text("Tomato Score", 99, 297, 159, 34);
  text("User Score", 99, 367, 165, 34);
  text("Rank", 99, 437, 437, 34);
  
  
  
  // x select box
  stroke(255);
  strokeWeight(1);
  noFill();
  rect(636, 676, 34, 34);
  rect(781, 676, 34, 34);
  noStroke();
  fill(255);
  text("Year", 671, 676, 85, 34);
  text("Genre", 818, 676, 85, 34);
  
  //// graph select box
  //stroke(255);
  //strokeWeight(1);
  //noFill();
  //rect(61, 633, 34, 34);
  //rect(61, 671, 34, 34);
  //noStroke();
  //fill(255);
  //text("Line", 98, 633, 100, 34);
  //text("Bar", 98, 671, 100, 34);
  //if (mouseX >= 61 && mouseX <= 61 + 34 && mouseY >= 633 && mouseY <= 633 + 34) {
  //  if (graph_mode.equals("Bar")) {
  //    fill(82, 189, 249);
  //    rect(61, 633, 34, 34);
  //    if (mouse_over_button_conditions) {
  //      mouse_over_button_conditions = false;
  //      graph_mode = "Line";
  //    }
  //  }
  //}
  //if (mouseX >= 61 && mouseX <= 61 + 34 && mouseY >= 671 && mouseY <= 671 + 34) {
  //  if (graph_mode.equals("Line")) {
  //    fill(82, 189, 249);
  //    rect(61, 671, 34, 34);
  //    if (mouse_over_button_conditions) {
  //      mouse_over_button_conditions = false;
  //      graph_mode = "Bar";
  //    }
  //  }
  //}
  //if (graph_mode.equals("Line")) {
  //  fill(130, 227, 90);
  //  rect(61, 633, 34, 34);
  //}
  //if (graph_mode.equals("Bar")) {
  //  fill(130, 227, 90);
  //  rect(61, 671, 34, 34);
  //}
  
  
  for (int i = 0; i<ax_x_b.length; i++) {
    if (mouseX >= ax_x_b[i] && mouseX <= ax_x_b[i] + l_b && mouseY >= ax_y_b[i] && mouseY <= ax_y_b[i] + l_b) {
      if (x_chk != i || x_chk == -1) {
        fill(82, 189, 249);
        rect(ax_x_b[i], ax_y_b[i], l_b, l_b);
      }
      if (mouse_over_button_conditions) {
        mouse_over_button_conditions = false;
        if (x_chk == i) {
          x_chk = -1;
          x_axis = "None";
        }
        else {
          x_chk = i;
          x_axis = xaxis[i];
        }
      }
    }
    if (x_chk == i) {
      fill(130, 227, 90);
      rect(ax_x_b[i], ax_y_b[i], l_b, l_b);
    }
  }
  
  for (int i = 0; i<ay_x_b.length; i++) {
    if (mouseX >= ay_x_b[i] && mouseX <= ay_x_b[i] + l_b && mouseY >= ay_y_b[i] && mouseY <= ay_y_b[i] + l_b) {
      if (y_chk != i || y_chk == -1) {
        fill(82, 189, 249);
        rect(ay_x_b[i], ay_y_b[i], l_b, l_b);
      }
      if (mouse_over_button_conditions) {
        mouse_over_button_conditions = false;
        if (y_chk == i) {
          y_chk = -1;
          y_axis = "None";
        }
        else {
          y_chk = i;
          y_axis = yaxis[i];
        }
      }
    }
    if (y_chk == i) {
      fill(130, 227, 90);
      rect(ay_x_b[i], ay_y_b[i], l_b, l_b);
    }
  }
}

String mode = "None";
void plus_button_click() {
  if (all_analyze == true) {
    all_analyze_page();
  }
  else {
    ///// when mouse button clicked, this function starts.
    noStroke();
    fill(0);
    rect(0, 0, width, height);
    
    image(saflix, 40, 10, 197*70/87, 70);
    
    ////////////select rect
    
    textSize(40);
    if (mouseX>=153 && mouseX <= 153+346 && mouseY>= 183 && mouseY<=183+115) {
      stroke(82, 189, 249);
      noFill();
      rect(153, 183, 346, 115, 10);
      textAlign(CENTER, CENTER);
      fill(82, 189, 249);
      noStroke();
      text("Pie Chart", 153, 183, 346, 115);
      textAlign(RIGHT);
      if (mouse_over_button_conditions) {
        mouse_over_button_conditions = false;
        screen_end = 1;
        all_analyze = true;
        mode = "pie";
      }
    }
    else {
      noFill();
      stroke(255);
      rect(153, 183, 346, 115, 10);
      textAlign(CENTER, CENTER);
      noStroke();
      fill(255);
      text("Pie Chart", 153, 183, 346, 115);
      textAlign(RIGHT);
    }
    
    if (mouseX>=775 && mouseX <= 775+346 && mouseY>= 183 && mouseY<=183+115) {
      stroke(82, 189, 249);
      noFill();
      rect(775, 185, 346, 115, 10);
      textAlign(CENTER, CENTER);
      noStroke();
      fill(82, 189, 249);
      text("Graph", 775, 185, 346, 115);
      textAlign(RIGHT);
      if (mouse_over_button_conditions) {
        mouse_over_button_conditions = false;
        screen_end = 1;
        all_analyze = true;
        mode = "Graph";
      }
    }
    else {
      noFill();
      stroke(255);
      rect(775, 185, 346, 115, 10);
      textAlign(CENTER, CENTER);
      noStroke();
      fill(225);
      text("Graph", 775, 185, 346, 115);
      textAlign(RIGHT);
    }
    
    noStroke();
    fill(180);
    textSize(24);
    textAlign(CENTER, TOP);
    text("If you click this button, you can see pie chart of movies. For this, we give you the pie chart of Genre, Year and Director.", 171, 314, 311, 279);
    text("If you click this button, you can see Bar graph and Line graph of movies. For this, we give you the chart of Scores, Rank, Year, Genre and Number of Evaluation.", 792, 314, 311, 279);
    textAlign(RIGHT);
    //////esc
    stroke(255);
    if (mouseX >= width-60 && mouseX <= width-60+30 && mouseY >= 50 && mouseY <= 80) {
      fill(255);
      if (mouse_over_button_conditions) {
        save_page = 0;
        screen_end = 1;
        mouse_button_clicked = false;
        genre_many_check = false;
      }
    }
    else noFill();
    rect(width-60, 50, 30, 30);
  }
}


int mouse_in_button = 0;
boolean mouse_button_clicked = false;

void plus_button() {
  int button_bigger_lvl = 0;
  float button_bigger = 0;
  if ((mouseX-(width-70))*(mouseX-(width-70))+(mouseY-(height-70))*(mouseY-(height-70)) <= 43 * 43) {
    mouse_in_button = 1;
    if (button_bigger_lvl < 5) button_bigger_lvl += 1;
    button_bigger = map(button_bigger_lvl, 0, 5, 0, 10);
    noStroke();
    fill(82, 189, 249, 220);
    ellipse(width-70, height-70, 50+button_bigger*2, 50+button_bigger*2);
    fill(0);
    ellipse(width-70, height-70, 43+button_bigger*2, 43+button_bigger*2);
    fill(82, 189, 249);
    rectMode(CENTER);
    rect(width-70, height-70, 7+button_bigger, 35+button_bigger, 3);
    rect(width-70, height-70, 35+button_bigger, 7+button_bigger, 3);
    rectMode(CORNER);
    
    if (mouse_over_button_conditions) {
      mouse_over_button_conditions = false;
      mouse_button_clicked = true;
      screen_end = 1;
    }
  }
  else if (button_bigger_lvl >0) {
    mouse_in_button = 0;
    button_bigger_lvl -= 1;
    button_bigger = map(button_bigger_lvl, 0, 5, 0, 10);
    noStroke();
    fill(200, 220);
    ellipse(width-70, height-70, 50+button_bigger*2, 50+button_bigger*2);
    fill(0);
    ellipse(width-70, height-70, 43+button_bigger*2, 43+button_bigger*2);
    fill(255);
    rectMode(CENTER);
    rect(width-70, height-70, 7+button_bigger, 35+button_bigger, 3);
    rect(width-70, height-70, 35+button_bigger, 7+button_bigger, 3);
  }
  else {
    mouse_in_button = 0;
    noStroke();
    fill(200, 220);
    ellipse(width-70, height-70, 50, 50);
    fill(0);
    ellipse(width-70, height-70, 43, 43);
    fill(255);
    rectMode(CENTER);
    rect(width-70, height-70, 7, 35, 3);
    rect(width-70, height-70, 35, 7, 3);
    rectMode(CORNER);
  }
}

color b1, b2;
int Y_AXIS = 1;
int X_AXIS = 2;

void setGradient(int x, int y, float w, float h, color c1, color c2, int axis ) {

  noFill();

  if (axis == Y_AXIS) {  // Top to bottom gradient
    for (int i = y; i <= y+h; i++) {
      float inter = map(i, y, y+h, 0, 250);
      fill(0, inter);
      rect(x, i, w, 1);
    }
  }  
  else if (axis == X_AXIS) {  // Left to right gradient
    for (int i = x; i <= x+w; i++) {
      float inter = map(i, x, x+w, 0, 250);
      fill(0, inter);
      rect(i, y, 1, h);
    }
  }
}

void screenChange() {
  if(screen_end == 1){
      ask_change_screen = 1;
      page_genre = 0;
      genre_mouse_click = 0;
      change_screen();
    }
}

void add_genre() {
  M_array.add(new Movie(the_number));
  ((Movie)M_array.get(M_array.size()-1)).get_score();
  the_number+=1;
  fill(0);
  rect(0,0,width, height);
  image(saflix, width/2-197*200/87/2, height/2-140, 197*200/87, 200);
  noStroke();
  fill(100);
  rect(width/2 - 400, height/2+100, 800, 8, 7);
  fill(255);
  rect(width/2 - 400, height/2+100, map(the_number, 0, amount, 0, 800), 8, 7);
}
 
int junk = 0;
void loadData(int numdum) {
  String loaddataurl = "https://www.rottentomatoes.com/top/bestofrt/" + genre_url[numdum];
  //println(url);
  String[] loaddatalines = {};
  String html;
  
  int did = 1;
  while (did == 1) {
    try {
      loaddatalines = loadStrings(loaddataurl);
      html = join(loaddatalines, "");
      did = 0;
    } catch (Exception e) {
      println("-------------wowawowa\n");
      did = 1;
    }
  }  
  
  String start = "<a href=\"/m/";
  String end = "\" class=\"";
  //println("============================");
  //println(loaddataurl);
  //println("============================");
  for (int i = 0; i<loaddatalines.length; i++) {
    fmoviename.add(giveMeTextBetween(loaddatalines[i], start, end));
    //if ((String)fmoviename.get(i) != "")
    //  println((String)fmoviename.get(i));
  }
  
  //println(int(fmoviename.size()));
  int rs = 0;
  int add_number = 0;
  for (int i = 0; i<int(fmoviename.size()); i++) {
    String t = (String)fmoviename.get(i);
    if (t != "") {
      if (rs >=3) {
        k+=15;
        moviename.add(t);
        add_number+=1;
      }
      else
        rs += 1;
    }
  }
  
  //int numunumunum = (int)movie_number.get(movie_number.size()-1)+add_number;
  //movie_number.add(numunumunum);
  
  //println("--------------");
  
  //println(moviename.size());
}

String giveMeTextBetween(String s, String before, String after) {
  int start = s.indexOf(before);
  if (start == -1) {
    return "";
  }
  
  start += before.length();
  int end = s.indexOf(after, start);
  if (end == -1) {
    return "";
  }
  
  return s.substring(start, end);
}

int down, upper;
void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  float t = (-320)*sin(map(e, -200, 200, -PI/2, PI/2));
  if (more == 0) {
    down = -7010+80-up;
    upper = 0;
  }
  else {
    down = -up - int((down_number-1)/5)*350;
    upper = save_page;
  }
  
  if (page <=0 && page + t < upper && page-save_page + t > down) {
    page += t;
  }
}

int change_screen_number = 250;
int ask_change_screen = 0;
void change_screen() {
  if (change_screen_number == 0) {
    change_screen_number = 250;
    ask_change_screen = 0;
    screen_end = 0;
  }
  if (ask_change_screen == 1) {
    fill(0, change_screen_number);
    rect(0, 0, width, height);
    change_screen_number -= 10;
  }
}
