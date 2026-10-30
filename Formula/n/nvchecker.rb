class Nvchecker < Formula
  include Language::Python::Virtualenv

  desc "New version checker for software releases"
  homepage "https://github.com/lilydjwg/nvchecker"
  url "https://files.pythonhosted.org/packages/be/43/e2b9699bb92a8125a24f2052152dfbfa4286285e6ea7aa7a47e8728ed72e/nvchecker-2.22.tar.gz"
  sha256 "7c5d04d55e3faffa2f7e7a81165a2f6b68786f4b185d4e1e2ec7af03a524e784"
  license "MIT"
  revision 3

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "eb4af1006a992c013d4ba52f8eca8c58cfd8eeecca56f6ca8e1aab66028b7117"
    sha256 cellar: :any, arm64_tahoe:       "9a024559a1bd7c2090b3f27dabe1794bf7b4d909a2bc19bd9d645ebee843dafc"
    sha256 cellar: :any, arm64_sequoia:     "20c0a1e45d6a07b2b1125643c5647acd47c243dfcdb1d9bf80162cd96e7e5c88"
    sha256 cellar: :any, arm64_linux:       "b32cf59cbc0d062347cad5cd6874e21dbf3af6aec3723b7fe32d748923573d7c"
    sha256 cellar: :any, x86_64_linux:      "ea18dd19dd725e4ba64fb8602c25ba3641f4d2532bc578ee7958b30865958d13"
  end

  depends_on "curl"
  depends_on "openssl@4"
  depends_on "python@3.15"

  pypi_packages package_name: "nvchecker[pypi]"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/35/e9/bf409046a91b6a9ca652e9b0ac3c39481674f6774e23e58b52315516099a/platformdirs-4.13.7.tar.gz"
    sha256 "f7f351c027d6632c30471124e1fdb6ac0fef9ccc5cbac1b34cb333431b1fc3e1"
  end

  resource "pycurl" do
    url "https://files.pythonhosted.org/packages/a6/b3/93b9b8b4ed45f4700b3f9fc40b5daf189e0badd71d0839a6ad09cefa2245/pycurl-7.49.0.tar.gz"
    sha256 "d4327da9dea72768f942f831bbaa5a64adca4d7c89f3141da7a833d3c600ab90"
  end

  resource "structlog" do
    url "https://files.pythonhosted.org/packages/5e/89/b4a0bcfdf4f71a3dea31379f095929613d7e4528a0996bca6aa964cd0dca/structlog-26.1.0.tar.gz"
    sha256 "f63a716cbd1b1291cf7661de7794b455acfa4c43c5bcf1630e6ad5ddc1adb3b7"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/d0/02/5f549b1ad5da6267ed1e1fac2eef69257b1979cc812497002499b7895ff9/tornado-6.6.tar.gz"
    sha256 "34c4aa916d7f2b2d5cadee2c6850f5a4a7f3d688cbf58399ea9bd3057af4abd5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    file = testpath/"example.toml"
    file.write <<~TOML
      [nvchecker]
      source = "pypi"
      pypi = "nvchecker"
    TOML

    output = JSON.parse(shell_output("#{bin}/nvchecker -c #{file} --logger=json"))
    assert_equal version.to_s, output["version"]
  end
end