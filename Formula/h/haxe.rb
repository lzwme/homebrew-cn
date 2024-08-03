class Haxe < Formula
  desc "Multi-platform programming language"
  homepage "https:haxe.org"
  license all_of: ["GPL-2.0-or-later", "MIT"]
  revision 1
  head "https:github.comHaxeFoundationhaxe.git", branch: "development"

  stable do
    url "https:github.comHaxeFoundationhaxe.git",
        tag:      "4.3.5",
        revision: "bd79571b89d719a45db7860d239da2164147dd15"

    # Backport support for mbedtls 3.x
    patch do
      url "https:github.comHaxeFoundationhaxecommitc3258892c3c829ddd9faddcc0167108e62c84390.patch?full_index=1"
      sha256 "d92fa85053ed4303f147e784e528380f6a0f6f08d35b5d93fbdfbf072ca7ed3e"
    end
    patch do
      url "https:github.comHaxeFoundationhaxecommit8149e5e66436b5dac8f8b3f3fa09b2aac3e7f9d8.patch?full_index=1"
      sha256 "ccd51482d2dd8f41788dbfce1a0b107206f7ba145045d63e0d5634b4633e754a"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "22f348b27b26e056b6dc9670c06979d01db3cdd432500ddf14c8c95b8ece79f3"
    sha256 cellar: :any,                 arm64_ventura:  "6eb064c4e1bdbb1fc09cddb7b2acf59496a9390ce380322bd8cfe10e5a909069"
    sha256 cellar: :any,                 arm64_monterey: "71e2a7a551f21d8898cdb320abffcd7eee9b199731140b8b6e43072d40174f47"
    sha256 cellar: :any,                 sonoma:         "15190dded793cb086fa7191b0ef1d55ed7ab37a442701838a9b7d9406fe2c300"
    sha256 cellar: :any,                 ventura:        "9fc36e59a7b13e26de53226b20a59c5fa52c090fd2550ffc4eae884de768c22c"
    sha256 cellar: :any,                 monterey:       "ab0fb58f43caaf6e228daa6d95de3c8b82aef1192f8c1c303eea4eddbadc6747"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03784e3c2a636bcd32d265ab22fff659239826e21a43eaefa0dc089338ad55ac"
  end

  depends_on "cmake" => :build
  depends_on "ocaml" => :build
  depends_on "opam" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls"
  depends_on "neko"
  depends_on "pcre2"
  depends_on "zlib" # due to `mysql-client`

  uses_from_macos "m4" => :build
  uses_from_macos "perl" => :build
  uses_from_macos "rsync" => :build
  uses_from_macos "unzip" => :build

  on_linux do
    depends_on "node" => :test
  end

  resource "String::ShellQuote" do
    url "https:cpan.metacpan.orgauthorsidRROROSCHString-ShellQuote-1.04.tar.gz"
    sha256 "e606365038ce20d646d255c805effdd32f86475f18d43ca75455b00e4d86dd35"
  end

  resource "IPC::System::Simple" do
    url "https:cpan.metacpan.orgauthorsidJJKJKEENANIPC-System-Simple-1.30.tar.gz"
    sha256 "22e6f5222b505ee513058fdca35ab7a1eab80539b98e5ca4a923a70a8ae9ba9e"
  end

  def install
    # Build requires targets to be built in specific order
    ENV.deparallelize

    ENV.prepend_create_path "PERL5LIB", libexec"libperl5"
    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make", "install"
      end
    end

    Dir.mktmpdir("opamroot") do |opamroot|
      ENV["OPAMROOT"] = opamroot
      ENV["OPAMYES"] = "1"
      ENV["ADD_REVISION"] = "1" if build.head?
      system "opam", "init", "--no-setup", "--disable-sandboxing"
      system "opam", "exec", "--", "opam", "pin", "add", "haxe", buildpath, "--no-action"
      system "opam", "exec", "--", "opam", "install", "haxe", "--deps-only", "--working-dir", "--no-depexts"
      system "opam", "exec", "--", "make"
    end

    # Rebuild haxelib as a valid binary
    cd "extrahaxelib_src" do
      system "cmake", ".", *std_cmake_args
      system "make"
    end
    rm "haxelib"
    cp "extrahaxelib_srchaxelib", "haxelib"

    bin.mkpath
    system "make", "install", "INSTALL_BIN_DIR=#{bin}",
           "INSTALL_LIB_DIR=#{lib}haxe", "INSTALL_STD_DIR=#{lib}haxestd"
  end

  def caveats
    <<~EOS
      Add the following line to your .bashrc or equivalent:
        export HAXE_STD_PATH="#{HOMEBREW_PREFIX}libhaxestd"
    EOS
  end

  test do
    ENV["HAXE_STD_PATH"] = HOMEBREW_PREFIX"libhaxestd"

    system bin"haxe", "-v", "Std"
    system bin"haxelib", "version"

    (testpath"HelloWorld.hx").write <<~EOS
      import js.html.Console;

      class HelloWorld {
          static function main() Console.log("Hello world!");
      }
    EOS
    system bin"haxe", "-js", "out.js", "-main", "HelloWorld"

    cmd = if OS.mac?
      "osascript -so -lJavaScript out.js 2>&1"
    else
      "node out.js"
    end
    assert_equal "Hello world!", shell_output(cmd).strip
  end
end