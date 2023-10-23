class Regipy < Formula
  include Language::Python::Virtualenv

  desc "Offline registry hive parsing tool"
  homepage "https://github.com/mkorman90/regipy"
  url "https://files.pythonhosted.org/packages/e0/f2/61846ba036f840b3cfe9b412dca3ef629bdc7506faafbd56b2c8de987950/regipy-3.1.6.tar.gz"
  sha256 "edc9fd8501f3374afd49020550bf361235e569959712825fbd2f444d2aeca8d9"
  license "MIT"
  head "https://github.com/mkorman90/regipy.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3c228285dae25a3651e6baba502a522837c8d2cc1076d6adaca7f8fc806a731c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41d0c06d9a4f35b4d6c2a90fe484940c92f564316cc5672a5d14dff0486f349b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b89c5207e8037065d74c6df55dd63633063ea4a039190901643bb44ab8858bba"
    sha256 cellar: :any_skip_relocation, sonoma:         "efa3c9158dedf6675c04ef54dd3126d57a35b4ad89c518d8be70cfb2df6bbda2"
    sha256 cellar: :any_skip_relocation, ventura:        "e94c00ab84ebed8cd117f98da53b6cace219a3e422af0ea7b8433d9d3102d85e"
    sha256 cellar: :any_skip_relocation, monterey:       "022f206299aebaa2f8319f3e040d91ce64094051939b61a2cc5acf02fcb3c4d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03872c4afcca0055fe5457ccdc5f87cc3eec37a3691af6f7e7b73b1e46e26017"
  end

  depends_on "python-click"
  depends_on "python-pytz"
  depends_on "python-tabulate"
  depends_on "python@3.12"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "construct" do
    url "https://files.pythonhosted.org/packages/e0/b7/a4a032e94bcfdff481f2e6fecd472794d9da09f474a2185ed33b2c7cad64/construct-2.10.68.tar.gz"
    sha256 "7b2a3fd8e5f597a5aa1d614c3bd516fa065db01704c72a1efaaeec6ef23d8b45"
  end

  resource "inflection" do
    url "https://files.pythonhosted.org/packages/e1/7e/691d061b7329bc8d54edbf0ec22fbfb2afe61facb681f9aaa9bff7a27d04/inflection-0.5.1.tar.gz"
    sha256 "1a29730d366e996aaacffb2f1f1cb9593dc38e2ddd30c91250c6dde09ea9b417"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    resource "homebrew-test_hive" do
      url "https://ghproxy.com/https://raw.githubusercontent.com/mkorman90/regipy/71acd6a65bdee11ff776dbd44870adad4632404c/regipy_tests/data/SYSTEM.xz"
      sha256 "b1582ab413f089e746da0528c2394f077d6f53dd4e68b877ffb2667bd027b0b0"
    end

    resource("homebrew-test_hive").stage do
      system bin/"registry-plugins-run", "-p", "computer_name", "-o", "out.json", "SYSTEM"
      h = JSON.parse(File.read("out.json"))
      assert_equal h["computer_name"][0]["name"], "WKS-WIN732BITA"
      assert_equal h["computer_name"][1]["name"], "WIN-V5T3CSP8U4H"
    end
  end
end