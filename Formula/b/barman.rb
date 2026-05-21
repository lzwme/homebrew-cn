class Barman < Formula
  include Language::Python::Virtualenv

  desc "Backup and Recovery Manager for PostgreSQL"
  homepage "https://www.pgbarman.org/"
  url "https://ghfast.top/https://github.com/EnterpriseDB/barman/releases/download/release%2F3.19.0/barman-3.19.0.tar.gz"
  sha256 "1c3ef54559908c779b0d96fd0d875d90939a809e14b84b1185fd20cfacf7dc20"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "375b1c07b901e7857934b8d83a281763b728a96324e6d85a8057b6583977e01e"
    sha256 cellar: :any,                 arm64_sequoia: "8489ab6f1ded27f5a6e031fd8eaaa431b5e15aeb8f09d26548ae938c5fa4cf1e"
    sha256 cellar: :any,                 arm64_sonoma:  "0554cd8a2516938cbf6e9a58a4f8064642188f078270d70271a2a93ff2037969"
    sha256 cellar: :any,                 sonoma:        "c295a571af796d49d9bcf181c35f473751897f1b9655017ce8e662e7978232fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "170ae6e3fe2cff946ae4463d0c604f995feea1c2be0701e82853cbde9e470391"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4db6857ebdf1503458ba5bb484e7167b1cbdaa3a4e32106c40cf79b7e598694c"
  end

  depends_on "libpq"
  depends_on "openssl@3"
  depends_on "python@3.14"

  resource "psycopg2" do
    url "https://files.pythonhosted.org/packages/c7/bc/f66df707ed1aec949fbf24e4460e4f4277a7ba23cdadb3965bb1f634ddb9/psycopg2-2.9.12.tar.gz"
    sha256 "1dedb1c7a1d8552c4a6044c6b1c41a52e6a8e2d144af83eccac758076b1b7c15"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/4f/db/cfac1baf10650ab4d1c111714410d2fbb77ac5a616db26775db562c8fab2/setuptools-82.0.1.tar.gz"
    sha256 "7d872682c5d01cfde07da7bccc7b65469d3dca203318515ada1de5eda35efbf9"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  def install
    virtualenv_install_with_resources
    etc.install "docs/barman.conf"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/barman --version")

    cp etc/"barman.conf", testpath
    inreplace "barman.conf", "barman_user = barman", "barman_user = #{ENV["USER"]}"
    system bin/"barman", "-c", "barman.conf", "list-servers"
  end
end