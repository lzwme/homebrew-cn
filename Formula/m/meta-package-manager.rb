class MetaPackageManager < Formula
  include Language::Python::Virtualenv
  include Language::Python::Shebang

  desc "Wrapper around all package managers with a unifying CLI"
  homepage "https://kdeldycke.github.io/meta-package-manager/"
  url "https://files.pythonhosted.org/packages/9e/d5/2efe713f05e8999d338f34750abf36b0c22fd669be6eedd72b0ae2b4440b/meta_package_manager-8.2.0.tar.gz"
  sha256 "8685fb34eaccc9471047e67adc1d2ddd42b92a5be9df5b9e12f166396b7f72b5"
  license "GPL-2.0-or-later"
  head "https://github.com/kdeldycke/meta-package-manager.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f203757f105f2eb0f080b4e2f5229c7e1d2491f3ceabd23510836823834e29ad"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fb83ceb748f1bc2da49e0ee15203c9ffbd98d94232c65c59a133c575eae44023"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "95227274e615335b404aa9dddbca198a6fca75c43414fcfe65fa24e9375fbb3c"
    sha256 cellar: :any,                 arm64_linux:       "72eda9bb7f3e8c4816494fd085225e7ca060991805c7a01e9548bf1ed6bc6179"
    sha256 cellar: :any,                 x86_64_linux:      "3c6bade4d999b4743c91f11ebf97e6ff12c72ce499da0f8bd7a3fd66b1dd570f"
  end

  depends_on "rust" => :build

  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.15"
  depends_on "rpds-py" => :no_linkage

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  pypi_packages exclude_packages: ["certifi", "rpds-py"]

  resource "boltons" do
    url "https://files.pythonhosted.org/packages/71/56/14c4a4931910a81ddeccfbe227925ea738e3c445d3e2af960f0bcbba1616/boltons-26.2.0.tar.gz"
    sha256 "d39cfd15c1a1c3bd4d705c82252fa9edb8e4f5e8cc039f8e39afac7b1b47e92c"
  end

  resource "bracex" do
    url "https://files.pythonhosted.org/packages/fb/37/adf8dd2cde958c2d086bdd87fc36b532fd824bf38f10be6348d65da0c8f9/bracex-3.2.tar.gz"
    sha256 "0a3d40bfae4caae4d3bfd0ea715874799fab711c38fd4012cc35343e815405cd"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "click-extra" do
    url "https://files.pythonhosted.org/packages/94/49/8f08a9dcff02255ade9898d7972e07a0e227b4151e040baac7c6499c4d07/click_extra-9.5.0.tar.gz"
    sha256 "d3187fddf72c3f2cffc0c38d345e3bdbec989a7b790a5fec473d85cd4d497943"
  end

  resource "cloup" do
    url "https://files.pythonhosted.org/packages/05/e2/d41446c6195eff0db3b671ddb202e39f42f9ea7c0dd15cd43fbf5cf0d7f7/cloup-4.0.0.tar.gz"
    sha256 "83b0870ee863bcc85129e40e1b208bcfdebe4cd2142e9ce1d0daf7d276cab038"
  end

  resource "deepmerge" do
    url "https://files.pythonhosted.org/packages/38/6e/5cb3548b4d3112fea529375e55e6f3cdc52b8054e3a66f203b1f888ba885/deepmerge-3.0.1.tar.gz"
    sha256 "35b39a4cb92cf328d6eca61cbbf65f68a37c2ceb3085f0f853cbb2e52a59fc23"
  end

  resource "extra-platforms" do
    url "https://files.pythonhosted.org/packages/3e/2f/c8f34db12c09070b47885d51e4f5cf722107442c3c423cb9a1eb5ec7047a/extra_platforms-13.13.0.tar.gz"
    sha256 "77f9927d5c3ca286241ccba049d4ac6d8256e3df123779e036148fc94d0ff583"
  end

  resource "packageurl-python" do
    url "https://files.pythonhosted.org/packages/f5/d6/3b5a4e3cfaef7a53869a26ceb034d1ff5e5c27c814ce77260a96d50ab7bb/packageurl_python-0.17.6.tar.gz"
    sha256 "1252ce3a102372ca6f86eb968e16f9014c4ba511c5c37d95a7f023e2ca6e5c25"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/46/58/8c37dea7bbf769b20d58e7ace7e5edfe65b849442b00ffcdd56be88697c6/tabulate-0.10.0.tar.gz"
    sha256 "e2cfde8f79420f6deeffdeda9aaec3b6bc5abce947655d17ac662b126e48a60d"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/19/75/241269d1da26b624c0d5e110e8149093c759b7a286138f4efd61a60e75fe/tomli_w-1.2.0.tar.gz"
    sha256 "2dd14fac5a47c27be9cd4c976af5a12d87fb1f0b4512f81d69cce3b35ae25021"
  end

  resource "wcmatch" do
    url "https://files.pythonhosted.org/packages/bd/07/b7a9162a804bc0f7d03fe84c93e374d3e1c4d828043d5f9b797f7d4e30e0/wcmatch-11.2.tar.gz"
    sha256 "1605bde546fbde4c063628c7d89eda486909fd4337e51d73a873987fbcb2554c"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/ea/01/e5ac23733628a6bbb91913a765fcf55ee8070d8d991bc88fdaaf805052c7/wcwidth-0.9.4.tar.gz"
    sha256 "fd8d57d3cdfe570e3265c8fab1885c24e34ef40889c0759c0c304a19e9835954"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/19/70/80f3b7c10d2630aa66414bf23d210386700aa390547278c789afa994fd7e/xmltodict-1.0.4.tar.gz"
    sha256 "6d94c9f834dd9e44514162799d344d815a3a4faec913717a9ecbfa5be1bb8e61"
  end

  def install
    rewrite_shebang detected_python_shebang, "meta_package_manager/bar_plugin.py"
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"mpm", shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mpm --version")

    # Check mpm is detecting brew and report it as a manager in a table row.
    assert_match "brew,Homebrew Formulae,✓,✓",
      shell_output("#{bin}/mpm --table-format csv --all-managers managers")
    # Check mpm is reporting itself as installed via brew in a table row.
    assert_match "meta-package-manager,,brew,#{version}", shell_output("#{bin}/mpm --table-format csv installed")
  end
end