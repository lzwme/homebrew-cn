class Nvchecker < Formula
  include Language::Python::Virtualenv

  desc "New version checker for software releases"
  homepage "https://github.com/lilydjwg/nvchecker"
  url "https://files.pythonhosted.org/packages/9c/1a/2dd119c062d5f32789098a23f2d0bc76ff6e3c6195578f91e22a97aec9b1/nvchecker-2.13.tar.gz"
  sha256 "17c69b7f9c13899a49aeccd7c094e88688aa89509d4cedb254d2c7b232879338"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "138c5f0955b5d0b472ad4e78c3534e8258f63c9593e062d26240bba5a482fc25"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3820de09d8185f922e84e5c58e530c3ba3278aa6d30103ceac5776153a46fa80"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e7fd7a1d9867d1b02386a10ebf8e797ee09af1b277e155a7ed054f62d8d0448"
    sha256 cellar: :any_skip_relocation, sonoma:         "b8368607d56a158882a6f74e194e4329039b3b5711e21e92ca3124dd449a9a04"
    sha256 cellar: :any_skip_relocation, ventura:        "d1db19133eecfbae4ab6ec8ebbd4e8eb8e1881227a41c7f2062bda44c8c026d1"
    sha256 cellar: :any_skip_relocation, monterey:       "ef56330fe36e4bc9f849c061a76f037294b3d1de2bf886a6ce685ee1244ab3b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbceb8ab25745117009fc2e8fa3a2d8cbc47b74f5c3d4c557d43f59eb1660bff"
  end

  depends_on "jq" => :test
  depends_on "python-packaging"
  depends_on "python-pycurl"
  depends_on "python@3.12"

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/62/d1/7feaaacb1a3faeba96c06e6c5091f90695cc0f94b7e8e1a3a3fe2b33ff9a/platformdirs-4.1.0.tar.gz"
    sha256 "906d548203468492d432bcb294d4bc2fff751bf84971fbb2c10918cc206ee420"
  end

  resource "structlog" do
    url "https://files.pythonhosted.org/packages/99/4c/67e8cc235bbeb0a87053739c4c9d0619e3f284730ebdb2b34349488d9e8a/structlog-23.2.0.tar.gz"
    sha256 "334666b94707f89dbc4c81a22a8ccd34449f0201d5b1ee097a030b577fa8c858"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/bd/a2/ea124343e3b8dd7712561fe56c4f92eda26865f5e1040b289203729186f2/tornado-6.4.tar.gz"
    sha256 "72291fa6e6bc84e626589f1c29d90a5a6d593ef5ae68052ee2ef000dfd273dee"
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