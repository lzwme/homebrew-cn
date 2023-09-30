class Nvchecker < Formula
  include Language::Python::Virtualenv

  desc "New version checker for software releases"
  homepage "https://github.com/lilydjwg/nvchecker"
  url "https://files.pythonhosted.org/packages/22/25/e42c9be788883c94ed3a2bbaf37c2351cfe0d82cdb96676a629ed3adedec/nvchecker-2.12.tar.gz"
  sha256 "4200ddf733448c52309f110c6fa916727a7400f444855afa8ffe7ff1e5b0b6c8"
  license "MIT"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "629ea45a90f3e89233858bb8a93f94f190f9c48d1d2f30358a688903ca123239"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "079e0d89e2de1eb842343d8b17f1123ea660bc7546bf8de3e1a1daae766532b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08ed62366a642353aa53f5ca4f9c7f25a6571c88df44f5eaa9c49e9502be414a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a207081ca818d3612e5fd73dc2e035360b62b5a02b6e4181feddad525c00a82"
    sha256 cellar: :any_skip_relocation, sonoma:         "524275673c9ddc808655e60c479e2e4d2b3e1b47de1c3f231a430ae3722fd4d4"
    sha256 cellar: :any_skip_relocation, ventura:        "d0b1350f7fa05d92ef511673afe50671d3b1264f24baa3ab7d77240d24a51c90"
    sha256 cellar: :any_skip_relocation, monterey:       "7d9bddb089cdb973d189fc3e62cf67f33094080acce7bb0daec3630b245d2991"
    sha256 cellar: :any_skip_relocation, big_sur:        "6460ce5f228a78ff2edc4072823d0fc6a6a0d6945711a7c2415ac81ee6358e06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "571577e757d6ae1a43737a68c0e09d7474482cd26960d7f2d1c5d5ceafa15e6a"
  end

  depends_on "jq" => :test
  depends_on "python-pycurl"
  depends_on "python@3.11"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/dc/99/c922839819f5d00d78b3a1057b5ceee3123c69b2216e776ddcb5a4c265ff/platformdirs-3.10.0.tar.gz"
    sha256 "b45696dab2d7cc691a3226759c0d3b00c47c8b6e293d96f6436f733303f77f6d"
  end

  resource "structlog" do
    url "https://files.pythonhosted.org/packages/9e/c4/688d14600f3a8afa31816ac95220f2548648e292c3ff2262057aa51ac2fb/structlog-23.1.0.tar.gz"
    sha256 "270d681dd7d163c11ba500bc914b2472d2b50a8ef00faa999ded5ff83a2f906b"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/48/64/679260ca0c3742e2236c693dc6c34fb8b153c14c21d2aa2077c5a01924d6/tornado-6.3.3.tar.gz"
    sha256 "e7d8db41c0181c80d76c982aacc442c0783a2c54d6400fe028954201a2e032fe"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    file = testpath/"example.toml"
    file.write <<~EOS
      [nvchecker]
      source = "pypi"
      pypi = "nvchecker"
    EOS

    out = shell_output("#{bin}/nvchecker -c #{file} --logger=json | jq '.[\"version\"]' ").strip
    assert_equal "\"#{version}\"", out
  end
end