class Nvchecker < Formula
  include Language::Python::Virtualenv

  desc "New version checker for software releases"
  homepage "https:github.comlilydjwgnvchecker"
  url "https:files.pythonhosted.orgpackages7b60fd880c869c6a03768fcfe44168d7667f036e2499c8816dd106440e201332nvchecker-2.15.1.tar.gz"
  sha256 "a2e2b0a8dd4545e83e0032e8d4a4d586c08e2d8378a61b637b45fdd4556f1167"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "09c0850dcc977b911c4a6f878b81ad5ec44a14664ec2ea4e0417fa9f2b474f04"
    sha256 cellar: :any,                 arm64_ventura:  "76712781500e90fc3a9842767090530c8b7ee91665ed33cb211f565cf70b7874"
    sha256 cellar: :any,                 arm64_monterey: "796eed64fb0d77614c5ae1eca63b90d99b854245144ec1282515e838b08fffa0"
    sha256 cellar: :any,                 sonoma:         "abe83eab99a16a0f6e13a2ac9c7e3684d881954dbda23d0d058ad85f616c85b4"
    sha256 cellar: :any,                 ventura:        "862d30b3c9c1e8d33841eb8258b705c934c25a964bcb11ec581ee8eeab15087c"
    sha256 cellar: :any,                 monterey:       "5535c97b6cdd31b5d60ec09621b4b76863e0243196fdd6c3f3fc83b6d9b129f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc873f8f96e79a17ffbff805aa0ccdb48e5d6cb041aa20c019e71407820df562"
  end

  depends_on "jq" => :test
  depends_on "curl"
  depends_on "python@3.12"

  resource "packaging" do
    url "https:files.pythonhosted.orgpackageseeb5b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4dpackaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackagesf5520763d1d976d5c262df53ddda8d8d4719eedf9594d046f117c25a27261a19platformdirs-4.2.2.tar.gz"
    sha256 "38b7b51f512eed9e84a22788b4bce1de17c0adb134d6becb09836e37d8654cd3"
  end

  resource "pycurl" do
    url "https:files.pythonhosted.orgpackagesc95ae68b8abbc1102113b7839e708ba04ef4c4b8b8a6da392832bb166d09ea72pycurl-7.45.3.tar.gz"
    sha256 "8c2471af9079ad798e1645ec0b0d3d4223db687379d17dd36a70637449f81d6b"
  end

  resource "structlog" do
    url "https:files.pythonhosted.orgpackages87879b237eda856dc3e72f2485e884f59fe0ee8be49aa2ce8eff3a425c388766structlog-24.2.0.tar.gz"
    sha256 "0e3fe74924a6d8857d3f612739efb94c72a7417d7c7c008d12276bca3b5bf13b"
  end

  resource "tornado" do
    url "https:files.pythonhosted.orgpackagesbda2ea124343e3b8dd7712561fe56c4f92eda26865f5e1040b289203729186f2tornado-6.4.tar.gz"
    sha256 "72291fa6e6bc84e626589f1c29d90a5a6d593ef5ae68052ee2ef000dfd273dee"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    file = testpath"example.toml"
    file.write <<~EOS
      [nvchecker]
      source = "pypi"
      pypi = "nvchecker"
    EOS

    out = shell_output("#{bin}nvchecker -c #{file} --logger=json | jq '.[\"version\"]' ").strip
    assert_equal "\"#{version}\"", out
  end
end