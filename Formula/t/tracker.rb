class Tracker < Formula
  desc "Library and daemon that is an efficient search engine and triplestore"
  homepage "https://gnome.pages.gitlab.gnome.org/tracker/"
  # pull from git tag to get submodules
  url "https://gitlab.gnome.org/GNOME/tracker.git",
      tag:      "3.6.0",
      revision: "624ef729966f2d9cf748321bd7bac822489fa8ed"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]

  # Tracker doesn't follow GNOME's "even-numbered minor is stable" version
  # scheme but they do appear to use 90+ minor/patch versions, which may
  # indicate unstable versions (e.g., 1.99.0, 2.2.99.0, etc.).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:(?!\.9\d)\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "1f5e4992b3fa05c595419f3c74bc6c1ed060d88713732c53b94bcbd7cca992ac"
    sha256 arm64_ventura:  "d1f4c659bc3bcb540267a77f037bc9fb2482729631d67a08fa85ef6b0bd395e4"
    sha256 arm64_monterey: "d20678b865cc20bb74fb8e94b723218f04df877f88eb04630466b85b70d3668d"
    sha256 sonoma:         "76b0f840a5a237480948a4eb0c3e669baedc2dc4bcdf645cf98191b366f92c85"
    sha256 ventura:        "fcb5fd3a9e459a7e22fc43f659c28f86f6be87d0f608f47cf2218f0f549cf45e"
    sha256 monterey:       "1f5bb1ce43ea8cf8b5d909f4d8c2f5c0696ee7c1f8af2deffe45c73320340cd1"
    sha256 x86_64_linux:   "d29cab10448fb77fe9bb36c19503b9b35663582294df079083c38775270fe66d"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "pygobject3" => :build
  depends_on "vala" => :build
  depends_on "dbus"
  depends_on "glib"
  depends_on "icu4c"
  depends_on "json-glib"
  depends_on "libsoup"
  depends_on "sqlite"

  uses_from_macos "python" => :build, since: :catalina
  uses_from_macos "libxml2"

  def install
    args = std_meson_args + %w[
      -Dman=false
      -Ddocs=false
      -Dsystemd_user_services=false
      -Dtests=false
      -Dsoup=soup3
      --force-fallback-for=gvdb
    ]

    ENV["DESTDIR"] = "/"
    system "meson", "setup", "build", *args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libtracker-sparql/tracker-sparql.h>

      gint main(gint argc, gchar *argv[]) {
        g_autoptr(GError) error = NULL;
        g_autoptr(GFile) ontology;
        g_autoptr(TrackerSparqlConnection) connection;
        g_autoptr(TrackerSparqlCursor) cursor;
        int i = 0;

        ontology = tracker_sparql_get_ontology_nepomuk();
        connection = tracker_sparql_connection_new(0, NULL, ontology, NULL, &error);

        if (error) {
          g_critical("Error: %s", error->message);
          return 1;
        }

        cursor = tracker_sparql_connection_query(connection, "SELECT ?r { ?r a rdfs:Resource }", NULL, &error);

        if (error) {
          g_critical("Couldn't query: %s", error->message);
          return 1;
        }

        while (tracker_sparql_cursor_next(cursor, NULL, &error)) {
          if (error) {
            g_critical("Couldn't get next: %s", error->message);
            return 1;
          }
          if (i++ < 5) {
            if (i == 1) {
              g_print("Printing first 5 results:");
            }

            g_print("%s", tracker_sparql_cursor_get_string(cursor, 0, NULL));
          }
        }

        return 0;
      }
    EOS
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["icu4c"].opt_lib/"pkgconfig" if OS.mac?
    flags = shell_output("pkg-config --cflags --libs tracker-sparql-3.0").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end