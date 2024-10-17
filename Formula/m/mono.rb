class Mono < Formula
  desc "Cross platform, open source .NET development framework"
  homepage "https:www.mono-project.com"
  url "https:github.commonomono.git",
      tag:      "mono-6.12.0.206",
      revision: "0cbf0e290c31adb476f9de0fa44b1d8829affa40"
  license "MIT"

  livecheck do
    url "https:www.mono-project.comdownloadstable"
    regex(href=.*?(\d+(?:\.\d+)+)[._-]macosi)
  end

  bottle do
    rebuild 2
    sha256 arm64_sonoma:  "e69f64033ac83adbf465fdc284e5d145f18b0759b0c866177fd65975ccaf58f7"
    sha256 arm64_ventura: "e1b8fc0bfbdc638a220abed1d2fa5b48a7790a5b1668bafb3252b8539b14965d"
    sha256 sonoma:        "bb0d701d0120bffedba03081a169a5cd6b679c5d437163daec0e2d2bf6e61652"
    sha256 ventura:       "749ada5c5fb3013cae9ba9e862655ca2cd397f0c558be85b7f65ebeb9191598e"
    sha256 x86_64_linux:  "7aea7983b72286cf2ce2e6438d2b846908359e6b577d76ad36ce32f8ac9691d7"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "python@3.13"

  uses_from_macos "unzip" => :build
  uses_from_macos "krb5"
  uses_from_macos "zlib"

  on_linux do
    depends_on "ca-certificates"
  end

  conflicts_with "xsd", because: "both install `xsd` binaries"
  conflicts_with cask: "mono-mdk"
  conflicts_with cask: "homebrewcask-versionsmono-mdk-for-visual-studio"
  conflicts_with "chicken", because: "both install `csc`, `csi` binaries"
  conflicts_with "pedump", because: "both install `pedump` binaries"

  # xbuild requires the .exe files inside the runtime directories to
  # be executable
  skip_clean "libmono"

  link_overwrite "libmono"
  link_overwrite "libcli"

  def install
    # Replace hardcoded usrshare directory. Paths like usrshare.mono,
    # usrshare.isolatedstorage, and usrsharetemplate are referenced in code.
    inreplace_files = %w[
      externalcorefxsrcSystem.Runtime.ExtensionssrcSystemEnvironment.Unix.cs
      mcsclasscorlibSystemEnvironment.cs
      mcsclasscorlibSystemEnvironment.iOS.cs
      manmono-configuration-crypto.1
      manmono.1
      manmozroots.1
    ]
    inreplace inreplace_files, %r{usrshare(?=["])}, pkgshare

    # Remove use of -flat_namespace. Upstreamed at
    # https:github.commonomonopull21257
    inreplace "monoprofilerMakefile.am", "-Wl,suppress -Wl,-flat_namespace", "-Wl,dynamic_lookup"

    system ".autogen.sh", "--disable-nls",
                           "--disable-silent-rules",
                           *std_configure_args
    system "make"
    system "make", "install"
    # mono-gdb.py and mono-sgen-gdb.py are meant to be loaded by gdb, not to be
    # run directly, so we move them out of bin
    libexec.install bin"mono-gdb.py", bin"mono-sgen-gdb.py"
  end

  def post_install
    system bin"cert-sync", Formula["ca-certificates"].pkgetc"cert.pem" if OS.linux?
  end

  def caveats
    <<~EOS
      To use the assemblies from other formulae you need to set:
        export MONO_GAC_PREFIX="#{HOMEBREW_PREFIX}"
    EOS
  end

  test do
    test_str = "Hello Homebrew"
    test_name = "hello.cs"
    (testpathtest_name).write <<~EOS
      public class Hello1
      {
         public static void Main()
         {
            System.Console.WriteLine("#{test_str}");
         }
      }
    EOS
    shell_output("#{bin}mcs #{test_name}")
    output = shell_output("#{bin}mono hello.exe")
    assert_match test_str, output.strip
  end
end