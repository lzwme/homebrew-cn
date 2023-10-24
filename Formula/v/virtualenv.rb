class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/8d/e9/f4550b3af1b5c71d42913430d325ca270ace65896bfd8ba04472566709cc/virtualenv-20.24.6.tar.gz"
  sha256 "02ece4f56fbf939dbbc33c0715159951d6bf14aaf5457b092e4548e1382455af"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f1747fc594898e939fdc68873c5e96db10d699851c34068f1917aca832d18031"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1faad4926ba33ec121078f21a3c2f2e81cfb847aba7139c6e90ab753a590d6e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84b7b3478e66c6fdeb4e0b62bb0d51d5d557ece9fb62ae19fcdd16a5d186556d"
    sha256 cellar: :any_skip_relocation, sonoma:         "907678670b14a8d1f172246574fb46665ed867bc0886e9fcb3408607a7217700"
    sha256 cellar: :any_skip_relocation, ventura:        "99a57bba8914e85ad90bccdda201f1d9cd7fcd64f82c51ec9761f64a3002244b"
    sha256 cellar: :any_skip_relocation, monterey:       "8cb65b08ff45e38f6857be6d8807a1be64851817b4eb6b123d7e254f7f21cb12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63eb3c9f4a1636f58f7f1e5b07d35b32866ee4775a4ab8cfa4eb1745f3be9d19"
  end

  depends_on "python@3.11"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/29/34/63be59bdf57b3a8a8dcc252ef45c40f3c018777dc8843d45dd9b869868f0/distlib-0.3.7.tar.gz"
    sha256 "9dafe54b34a028eafd95039d5e5d4851a13734540f1331060d31c9916e7147a8"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/d5/71/bb1326535231229dd69a9dd2e338f6f54b2d57bd88fc4a52285c0ab8a5f6/filelock-3.12.4.tar.gz"
    sha256 "2e6f249f1f3654291606e046b09f1fd5eac39b360664c27f5aad072012f8bcbd"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/d3/e3/aa14d6b2c379fbb005993514988d956f1b9fdccd9cbe78ec0dbe5fb79bf5/platformdirs-3.11.0.tar.gz"
    sha256 "cf8ee52a3afdb965072dcc652433e0c7e3e40cf5ea1477cd4b3b1d2eb75495b3"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end