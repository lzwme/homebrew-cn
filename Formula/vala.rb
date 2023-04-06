class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.56/vala-0.56.6.tar.xz"
  sha256 "050e841cbfe2b8e7d0fb350c9506bd7557be1cd86a90c896765f1a09a1870013"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_ventura:  "0b3cddf89815d19eacd667449ce874880fecd27621ea941e1b7bfca55b3ec231"
    sha256 arm64_monterey: "ac7e718efbe67e873a96d98fd0783bf72f365a64603991be2630e104a155e9a8"
    sha256 arm64_big_sur:  "a21b10db6753b9f36766c45ce50512908d787e2b6cab77fe122a5c698110c383"
    sha256 ventura:        "72e7a8af9e4bb146bc2379d3a89273b289fd9522e1bf4fa38e839e20023a883a"
    sha256 monterey:       "f2c051fb0552d9f8d61891cc9d579896e94330983957a2b48f5301363096aef7"
    sha256 big_sur:        "cf83ae265412ce5779424e6911335bc3833c6140e9d3f4350dec6426f3f2c863"
    sha256 x86_64_linux:   "17cc434a9311bfb60e4166ac17c3c9e978e5a59940049cd39eb885f3d658c5de"
  end

  depends_on "glib"
  depends_on "graphviz"
  depends_on "pkg-config"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "libxslt" => :build # for xsltproc

  on_macos do
    depends_on "gettext"
  end

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make" # Fails to compile as a single step
    system "make", "install"
  end

  test do
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libffi"].opt_lib/"pkgconfig"
    test_string = "Hello Homebrew\n"
    path = testpath/"hello.vala"
    path.write <<~EOS
      void main () {
        print ("#{test_string}");
      }
    EOS
    valac_args = [
      # Build with debugging symbols.
      "-g",
      # Use Homebrew's default C compiler.
      "--cc=#{ENV.cc}",
      # Save generated C source code.
      "--save-temps",
      # Vala source code path.
      path.to_s,
    ]
    system "#{bin}/valac", *valac_args
    assert_predicate testpath/"hello.c", :exist?

    assert_equal test_string, shell_output("#{testpath}/hello")
  end
end