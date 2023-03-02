class Snakefmt < Formula
  include Language::Python::Virtualenv

  desc "Snakemake code formatter"
  homepage "https://github.com/snakemake/snakefmt/"
  url "https://files.pythonhosted.org/packages/dd/2a/7e2bf9b7e61c23b39d15fbb4b5ea0e48c5ebca15be54b9887810621b24ef/snakefmt-0.8.1.tar.gz"
  sha256 "73158bf48645603ead6f0aacbfe4f43cf8dc0fbd192fbac813a3e64baaee995f"
  license "MIT"
  head "https://github.com/snakemake/snakefmt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0bb8a4ad3d7179d4b3d0a83c9b6d0bb169662b17dee655f88d092c86c60d1d6b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50ba4aa16c13b7d5cc04ed2c27ae4e9841646c95f86bc50166a660bac3aa6177"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "249dea34414960cfa9d8d38c936ce48fad6ca0d2233310cca1f4dd11b923f29f"
    sha256 cellar: :any_skip_relocation, ventura:        "329b59822a904ebd347c7a722252a8d50374c198c44d9829402537c76e10e190"
    sha256 cellar: :any_skip_relocation, monterey:       "e6567d6b7870482c1750b1242e4fac557578a5638240db425aab4411122958fb"
    sha256 cellar: :any_skip_relocation, big_sur:        "e2d5043c74d16142c956ae25c2717bf9c16a12745c0a3d89239df9c28dfc9753"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de1faae813213e2ffe111960ec7751a74627cbfd3d3a688d50e3647af57358d3"
  end

  depends_on "cmake" => :build
  depends_on "black"
  depends_on "python@3.11"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "rust" => :build
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  def install
    virtualenv_install_with_resources

    site_packages = Language::Python.site_packages("python3.11")
    black = Formula["black"].opt_libexec
    (libexec/site_packages/"homebrew-black.pth").write black/site_packages
  end

  test do
    test_file = testpath/"Snakefile"
    test_file.write <<~EOS
      rule testme:
          output:
               "test.out"
          shell:
               "touch {output}"
    EOS
    test_output = shell_output("#{bin}/snakefmt --check #{test_file} 2>&1", 1)
    assert_match "[INFO] 1 file(s) would be changed 😬", test_output

    assert_match "snakefmt, version #{version}",
      shell_output("#{bin}/snakefmt --version")
  end
end