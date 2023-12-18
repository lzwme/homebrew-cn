class Haxe < Formula
  desc "Multi-platform programming language"
  homepage "https:haxe.org"
  url "https:github.comHaxeFoundationhaxe.git",
      tag:      "4.3.3",
      revision: "de2888959192e92ad5849b2b66c2782ba775adcc"
  license all_of: ["GPL-2.0-or-later", "MIT"]
  head "https:github.comHaxeFoundationhaxe.git", branch: "development"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4868b7152dda157816912d7a254c21061aafd674c2b18d84e7707989e7445f20"
    sha256 cellar: :any,                 arm64_ventura:  "9657a44ee0ba183f3bbe994f6a0db0a881f6a51bc711d0971ea11fc20e3e69c8"
    sha256 cellar: :any,                 arm64_monterey: "b317f48bc9e93ceff3b63c7fac815c5b81768c06854e8494737c0110769f9c83"
    sha256 cellar: :any,                 sonoma:         "fc1aa4d01cc93947431c7bc0717e64afa29e0060ec3779dbef925dfed7c64db4"
    sha256 cellar: :any,                 ventura:        "06730c05476dab57e787114c08411a1dac4dfe4ccbedbef034b48e828cd88d4e"
    sha256 cellar: :any,                 monterey:       "c4f2f48763d27c3ce411e0639dcfa1d89aaabe951157e3121752a05485e28efe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "297bb2908f22b1bbf233ec1035f825bdca20f81b3003646cb7f7701ec58aa2be"
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