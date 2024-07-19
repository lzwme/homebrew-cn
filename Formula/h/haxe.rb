class Haxe < Formula
  desc "Multi-platform programming language"
  homepage "https:haxe.org"
  url "https:github.comHaxeFoundationhaxe.git",
      tag:      "4.3.5",
      revision: "bd79571b89d719a45db7860d239da2164147dd15"
  license all_of: ["GPL-2.0-or-later", "MIT"]
  head "https:github.comHaxeFoundationhaxe.git", branch: "development"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3fe30810c879e767d4b3600d124833fd36da313710a040dd91ae84f8b76270fc"
    sha256 cellar: :any,                 arm64_ventura:  "fbab7bd3dabe61ea47f86b486e9083e3a4b66041ae0078fe2183fbdc05117b04"
    sha256 cellar: :any,                 arm64_monterey: "69a73f67e274c408761335bb785b9b8479a5607852398577712d8f5be2b78068"
    sha256 cellar: :any,                 sonoma:         "a1a5d74b5fbf63e09a5d041f0abbf3ae1ed04c148d66b24832031c33939754d7"
    sha256 cellar: :any,                 ventura:        "555732d7641db00b51b26a729e18572b70cad6f701792963ac4d31d0d98c19b7"
    sha256 cellar: :any,                 monterey:       "0e033a41f513729246856f106be2d61692131816f5777215f722b46bdc76ebd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27a2ba600631f62011e54244b77b922de4b4b5dc3aa331e7e2615c86fcf84914"
  end

  depends_on "cmake" => :build
  depends_on "ocaml" => :build
  depends_on "opam" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"
  depends_on "neko"
  depends_on "pcre2"

  uses_from_macos "m4" => :build
  uses_from_macos "perl" => :build
  uses_from_macos "rsync" => :build
  uses_from_macos "unzip" => :build
  uses_from_macos "zlib"

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
    ENV["HAXE_STD_PATH"] = "#{HOMEBREW_PREFIX}libhaxestd"
    system "#{bin}haxe", "-v", "Std"
    system "#{bin}haxelib", "version"

    (testpath"HelloWorld.hx").write <<~EOS
      import js.html.Console;

      class HelloWorld {
          static function main() Console.log("Hello world!");
      }
    EOS
    system "#{bin}haxe", "-js", "out.js", "-main", "HelloWorld"

    cmd = if OS.mac?
      "osascript -so -lJavaScript out.js 2>&1"
    else
      "node out.js"
    end
    assert_equal "Hello world!", shell_output(cmd).strip
  end
end