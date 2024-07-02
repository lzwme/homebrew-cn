class Redo < Formula
  include Language::Python::Virtualenv

  desc "Implements djb's redo: an alternative to make"
  homepage "https:redo.rtfd.io"
  url "https:github.comapenwarrredoarchiverefstagsredo-0.42d.tar.gz"
  sha256 "47056b429ff5f85f593dcba21bae7bc6a16208a56b189424eae3de5f2e79abc1"
  license "Apache-2.0"
  revision 2

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d8b48f458241e4a50346dfd5b317794688a2af43c7bdc00c18e16466846b26a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d8b48f458241e4a50346dfd5b317794688a2af43c7bdc00c18e16466846b26a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8b48f458241e4a50346dfd5b317794688a2af43c7bdc00c18e16466846b26a6"
    sha256 cellar: :any_skip_relocation, sonoma:         "d8b48f458241e4a50346dfd5b317794688a2af43c7bdc00c18e16466846b26a6"
    sha256 cellar: :any_skip_relocation, ventura:        "d8b48f458241e4a50346dfd5b317794688a2af43c7bdc00c18e16466846b26a6"
    sha256 cellar: :any_skip_relocation, monterey:       "d8b48f458241e4a50346dfd5b317794688a2af43c7bdc00c18e16466846b26a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dfa4beea88424e7b19d7938c44499dadec311a123cdb3a532db55a26b3ad5561"
  end

  depends_on "python@3.12"

  conflicts_with "goredo", because: "both install `redo` and `redo-*` binaries"

  resource "beautifulsoup4" do
    url "https:files.pythonhosted.orgpackagesb3ca824b1195773ce6166d388573fc106ce56d4a805bd7427b624e063596ec58beautifulsoup4-4.12.3.tar.gz"
    sha256 "74e3d1928edc070d21748185c46e3fb33490f22f52a3addee9aee0f4f7781051"
  end

  resource "markdown" do
    url "https:files.pythonhosted.orgpackages1128c5441a6642681d92de56063fa7984df56f783d3f1eba518dc3e7a253b606Markdown-3.5.2.tar.gz"
    sha256 "e1ac7b3dc550ee80e602e71c1d168002f062e49f1b11e26a36264dafd4df2ef8"
  end

  resource "soupsieve" do
    url "https:files.pythonhosted.orgpackagesce21952a240de1c196c7e3fbcd4e559681f0419b1280c617db21157a0390717bsoupsieve-2.5.tar.gz"
    sha256 "5663d5a7b3bfaeee0bc4372e7fc48f9cff4940b3eec54a6451cc5299f1097690"
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