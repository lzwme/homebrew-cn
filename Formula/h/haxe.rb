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
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a01ebb32b777699f9eb0c15b196b92de280c29eedb54a53240a474eda00171d7"
    sha256 cellar: :any,                 arm64_ventura:  "4aca1425acb2bced5bb9bdbe5cdb5e62c7016c8731aa166e5668a7a3bc4f99f0"
    sha256 cellar: :any,                 arm64_monterey: "09e20c7c0c2336251a349bb64c9a8bb5112aa10c4a6a6533118a55a940194d22"
    sha256 cellar: :any,                 sonoma:         "2c857d8e2946fa8074dce844d736e29af846ee777acf4598542ee593a1b4891a"
    sha256 cellar: :any,                 ventura:        "0e9d228cc81520c1dc3db1e11ef31d4a52d70891b558ab03dd50b62a51f46d3f"
    sha256 cellar: :any,                 monterey:       "53ae494360dbce3cc33e7b774d857c191dfb577c5b7c5358128c693242cec064"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ef436480178b687571c61f4494f4f5a1e51a8d22557825eed4ad9fe2c3e79b0"
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