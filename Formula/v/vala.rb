class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.56/vala-0.56.14.tar.xz"
  sha256 "9382c268ca9bdc02aaedc8152a9818bf3935273041f629c56de410e360a3f557"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sonoma:   "e9f8d18e71e9fc2f0583e9d5ff612de2782dbfbc7e14d36297c7fb1367ff75fd"
    sha256 arm64_ventura:  "a3c7a4db6bf33795b1e18234c67848194097e993dcba8f58ff3cac758ff50c80"
    sha256 arm64_monterey: "062f3feb6430f783dff4cd748cdbc9883f1682cb1b3c84ecf6514cc2a90d4981"
    sha256 sonoma:         "3ed12a8d08b6b5c5f3594584ec8a166d9f49f740866241002ba2b663c99b2ba8"
    sha256 ventura:        "aa3ac4565028cf928db3f3bcc4181764c0943ac9acd0dc3fc25a109c03a056b4"
    sha256 monterey:       "c20b5a583d6ef989a9abf754d8ecc6cd9f0a01279a9b100c6e81f6b262c8bf00"
    sha256 x86_64_linux:   "67f2ba93201fc7b94bc3281ad8613a1573c83000719937736f54bb33ec6e82fb"
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