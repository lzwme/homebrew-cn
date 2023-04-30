class Breezy < Formula
  include Language::Python::Virtualenv

  desc "Version control system implemented in Python with multi-format support"
  homepage "https://www.breezy-vcs.org/"
  url "https://files.pythonhosted.org/packages/ad/0e/4a937454a5a9e4d2ba7fcb37aeb64c082cddd3fd2761e445a5e11fcfd382/breezy-3.3.2.tar.gz"
  sha256 "4ea6949fcbb076b978545b099fac68abad35d6fa1899deef4f6b82a3dba257c1"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_ventura:  "e02f1814e6122fffd291014e049f1e94c9deab83a46c29a8076735b85e30ba7b"
    sha256 cellar: :any,                 arm64_monterey: "d4c32887afb4a0c0904fed6fd21684c91abf2bf7dd91322d2e9c13824df809d2"
    sha256 cellar: :any,                 arm64_big_sur:  "1a70c993590f13ba5b62e827e2287a42da859b830a631a08a067137c862e3a31"
    sha256 cellar: :any,                 ventura:        "df6a725ebf2a071f364314f05af40a91c498fdd3a80a1d49be36b30ddaaaec80"
    sha256 cellar: :any,                 monterey:       "a2c2496e3e57868f2a203e71732b63675c7e379feee38f488407b1541dac9e3c"
    sha256 cellar: :any,                 big_sur:        "b219ca1581f43a31d8b756299987e9a111b5cc414810663ff0c4f1c3566a2450"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4016dff3d9ac02791773dddbb88f586d712ffd336ecc23c76bec2c1c10e40cee"
  end

  depends_on "gettext" => :build
  depends_on "rust" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  conflicts_with "bazaar", because: "both install `bzr` binaries"

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/cb/87/17d4c6d634c044ab08b11c0cd2a8a136d103713d438f8792d7be2c5148fb/configobj-5.0.8.tar.gz"
    sha256 "6f704434a07dc4f4dc7c9a745172c1cad449feb548febd9f7fe362629c627a97"
  end

  resource "dulwich" do
    url "https://files.pythonhosted.org/packages/53/a8/c96686cd8e2b0875dbd7d3248c158ff07f2c0ce41857700711a92e97b463/dulwich-0.21.3.tar.gz"
    sha256 "7ca3b453d767eb83b3ec58f0cfcdc934875a341cdfdb0dc55c1431c96608cf83"
  end

  resource "fastbencode" do
    url "https://files.pythonhosted.org/packages/20/ab/33ca3005953d689f1be9c1e0662f5359b7365479f7a8fbd66cb05e9a840d/fastbencode-0.2.tar.gz"
    sha256 "578eb9c4700d6705d71fbc8d7d57bca2cd987eca2cec1d9e77b9e0702db1e56f"
  end

  resource "merge3" do
    url "https://files.pythonhosted.org/packages/dc/91/647a2942b6f308c7dce358bec770fe62ee0689cfd1dd218b66e244acde7d/merge3-0.0.13.tar.gz"
    sha256 "8abda1d2d49776323d23d09bfdd80d943a57d43d28d6152ffd2c87956a9b6b54"
  end

  resource "patiencediff" do
    url "https://files.pythonhosted.org/packages/bf/15/313ca3a72a2c23844002b20171e5c8c0688c1bb640752eb1d35bbe62eda0/patiencediff-0.2.13.tar.gz"
    sha256 "01d642d876186a8f0dd08e77ef1da1940ce49df295477e0713bdc66368e9d8d1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/aa/52/078c46565a4b4983e15d862cb7461e5c63a2e7b3c8436e8622a601120ea0/urllib3-2.0.0.tar.gz"
    sha256 "da21131828d290d6331d0d93a18f062ead1ec4fe0cfebbcefc95ee5368f7188a"
  end

  def install
    virtualenv_install_with_resources
    bin.each_child do |f|
      f.unlink
      f.write_env_script libexec/"bin"/f.basename, PATH: "#{libexec}/bin:$PATH"
    end
    man1.install_symlink Dir[libexec/"man/man1/*.1"]

    # Replace bazaar with breezy
    bin.install_symlink "brz" => "bzr"
  end

  test do
    brz = "#{bin}/brz"
    whoami = "Homebrew <homebrew@example.com>"
    system brz, "whoami", whoami
    assert_match whoami, shell_output("#{bin}/brz whoami")

    # Test bazaar compatibility
    system brz, "init-repo", "sample"
    system brz, "init", "sample/trunk"
    touch testpath/"sample/trunk/test.txt"
    cd "sample/trunk" do
      system brz, "add", "test.txt"
      system brz, "commit", "-m", "test"
    end

    # Test git compatibility
    system brz, "init", "--git", "sample2"
    touch testpath/"sample2/test.txt"
    cd "sample2" do
      system brz, "add", "test.txt"
      system brz, "commit", "-m", "test"
    end
  end
end