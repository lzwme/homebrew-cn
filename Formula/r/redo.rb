class Redo < Formula
  include Language::Python::Virtualenv

  desc "Implements djb's redo: an alternative to make"
  homepage "https:redo.rtfd.io"
  url "https:github.comapenwarrredoarchiverefstagsredo-0.42d.tar.gz"
  sha256 "47056b429ff5f85f593dcba21bae7bc6a16208a56b189424eae3de5f2e79abc1"
  license "Apache-2.0"
  revision 2

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6e8da91520948cb3d4fa12e3ab21d96eb2524f000022e23f5612bd068b0695e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e8da91520948cb3d4fa12e3ab21d96eb2524f000022e23f5612bd068b0695e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e8da91520948cb3d4fa12e3ab21d96eb2524f000022e23f5612bd068b0695e9"
    sha256 cellar: :any_skip_relocation, sonoma:         "6e8da91520948cb3d4fa12e3ab21d96eb2524f000022e23f5612bd068b0695e9"
    sha256 cellar: :any_skip_relocation, ventura:        "6e8da91520948cb3d4fa12e3ab21d96eb2524f000022e23f5612bd068b0695e9"
    sha256 cellar: :any_skip_relocation, monterey:       "6e8da91520948cb3d4fa12e3ab21d96eb2524f000022e23f5612bd068b0695e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d00ceaedc38e851648a18f9e76f013d3f14f1e147e046bfb0011bad9c2bc896d"
  end

  depends_on "python-markdown"
  depends_on "python@3.12"

  resource "beautifulsoup4" do
    url "https:files.pythonhosted.orgpackagese8b0cd2b968000577ec5ce6c741a54d846dfa402372369b8b6861720aa9ecea7beautifulsoup4-4.11.1.tar.gz"
    sha256 "ad9aa55b65ef2808eb405f46cf74df7fcb7044d5cbc26487f96eb2ef2e436693"
  end

  resource "soupsieve" do
    url "https:files.pythonhosted.orgpackagesf303bac179d539362319b4779a00764e95f7542f4920084163db6b0fd4742d38soupsieve-2.3.2.post1.tar.gz"
    sha256 "fc53893b3da2c33de295667a0e19f078c14bf86544af307354de5fcf12a3f30d"
  end

  def install
    python3 = "python3.12"
    # Prevent system Python 2 from being detected
    inreplace "redowhichpython.do", " python python3 python2 python2.7;", " #{python3};"

    # Prepare build-only virtualenv for generating manpages.
    venv = virtualenv_create(buildpath"venv", python3)
    venv.pip_install resources

    # Set PYTHONPATH rather than prepending PATH with venv as shebangs are set to detected python.
    ENV.prepend_path "PYTHONPATH", buildpath"venv"Language::Python.site_packages(python3)

    ENV["DESTDIR"] = ""
    ENV["PREFIX"] = prefix
    system ".do", "install"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}redo --version").strip
    # Make sure man pages were generated and installed
    assert_predicate man1"redo.1", :exist?

    # Test is based on https:redo.readthedocs.ioenlatestcookbookhello
    (testpath"hello.c").write <<~EOS
      #include <stdio.h>

      int main() {
        printf("Hello, world!\\n");
        return 0;
      }
    EOS
    (testpath"hello.do").write <<~EOS
      redo-ifchange hello.c
      cc -o $3 hello.c -Wall
    EOS
    assert_match "redo  hello", shell_output("#{bin}redo hello 2>&1").strip
    assert_predicate testpath"hello", :exist?
    assert_equal "Hello, world!\n", shell_output(".hello")
    assert_match "redo  hello", shell_output("#{bin}redo hello 2>&1").strip
    refute_match "redo", shell_output("#{bin}redo-ifchange hello 2>&1").strip
    touch "hello.c"
    assert_match "redo  hello", shell_output("#{bin}redo-ifchange hello 2>&1").strip
    (testpath"all.do").write("redo-ifchange hello")
    (testpath"hello").unlink
    assert_match "redo  all\nredo    hello", shell_output("#{bin}redo 2>&1").strip
  end
end