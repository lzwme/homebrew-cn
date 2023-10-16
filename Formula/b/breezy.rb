class Breezy < Formula
  include Language::Python::Virtualenv

  desc "Version control system implemented in Python with multi-format support"
  homepage "https://www.breezy-vcs.org/"
  url "https://files.pythonhosted.org/packages/5d/6e/cf538824a8ee831c761714f57803da7ba556e2bdfacd039ce8e5f27cbf98/breezy-3.3.4.tar.gz"
  sha256 "7c412f39fa3c616871fb1ba2a83fca36cb65b28e7f2b55c99c663ae2d90b2301"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "2f8194bdd0afacc87396b6bbc8c4d6b55320d47d85eeb6ee65e75fa091b24a1b"
    sha256 cellar: :any,                 arm64_ventura:  "7bbe1259468d58ad3522e0952a80b3b5f5358004b163946ce5fd52c293ee107e"
    sha256 cellar: :any,                 arm64_monterey: "e98bf97cde3ea7ce268b1a0a8695ec6eb9f3c91dc1e460d356cb8b38996b1c72"
    sha256 cellar: :any,                 sonoma:         "87c30fdc83806e6278064c30311cf3cf22827ce8d383413d93af44b9a7e37ac8"
    sha256 cellar: :any,                 ventura:        "8554749d48049d009ef3398f8453375b95df3ba9650cee057f0f1713a95a65b3"
    sha256 cellar: :any,                 monterey:       "d16cbbc92338c0306b13792500d469500510c6671bd1e146844a0afbd1aab5da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "059795b93f5776764382b57fd0b401b8a18fff04a4cfcefcea23bdaddfe7ccf4"
  end

  depends_on "gettext" => :build
  depends_on "rust" => :build
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"
  uses_from_macos "openssl"

  conflicts_with "bazaar", because: "both install `bzr` binaries"

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/cb/87/17d4c6d634c044ab08b11c0cd2a8a136d103713d438f8792d7be2c5148fb/configobj-5.0.8.tar.gz"
    sha256 "6f704434a07dc4f4dc7c9a745172c1cad449feb548febd9f7fe362629c627a97"
  end

  resource "dulwich" do
    url "https://files.pythonhosted.org/packages/57/e0/1b5f95c2651284a5d4fdfb2cc5ecad57fb694084cce59d9d4acb7ac30ecf/dulwich-0.21.6.tar.gz"
    sha256 "30fbe87e8b51f3813c131e2841c86d007434d160bd16db586b40d47f31dd05b0"
  end

  resource "fastbencode" do
    url "https://files.pythonhosted.org/packages/20/ab/33ca3005953d689f1be9c1e0662f5359b7365479f7a8fbd66cb05e9a840d/fastbencode-0.2.tar.gz"
    sha256 "578eb9c4700d6705d71fbc8d7d57bca2cd987eca2cec1d9e77b9e0702db1e56f"
  end

  resource "merge3" do
    url "https://files.pythonhosted.org/packages/af/40/98be4a5641b0244be5881ff5e00057f8227ff183d8675a697bdfeae43b1a/merge3-0.0.14.tar.gz"
    sha256 "30406e99386f4a65280fb9c43e681890fa2a1d839cac2759d156c7cc16030159"
  end

  resource "patiencediff" do
    url "https://files.pythonhosted.org/packages/57/9f/0973293d232696ae191cef7c4e8eb1ebbdb7728c48662ebf04c26fd576e4/patiencediff-0.2.14.tar.gz"
    sha256 "a604d5727f996f0fd9de4534b143d3e803ec4f1b18e40cd78e91ab48a289a95f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8b/00/db794bb94bf09cadb4ecd031c4295dd4e3536db4da958e20331d95f1edb7/urllib3-2.0.6.tar.gz"
    sha256 "b19e1a85d206b56d7df1d5e683df4a7725252a964e3993648dd0fb5a1c157564"
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