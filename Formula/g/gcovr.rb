class Gcovr < Formula
  include Language::Python::Virtualenv

  desc "Reports from gcov test coverage program"
  homepage "https:gcovr.com"
  url "https:files.pythonhosted.orgpackages32217f9967a2d5a37d8f77e793ba4c173d0e1e59195028c997a9947b73b652f4gcovr-8.2.tar.gz"
  sha256 "9a1dddd4585d13ec77555db5d6b6a31ee81587ea6fc604ff9fcd232cb0782df5"
  license "BSD-3-Clause"
  revision 1
  head "https:github.comgcovrgcovr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a09146bcee614db137253e92cc1b78eb60ca8a7827b572179756f72f1b0990e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ce9dfe3b5deb35b8dc6e6b1cf4ed97522468f70badb276aea37073772daec56"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b0713667a59b6036abd8e80a8b871ca88b89278fbd2cc6c87a3d535a844d933e"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ee6e3c4f93a745a2b3fbc3a7a42111796980cb3c9bb3cd862cf98f5de319345"
    sha256 cellar: :any_skip_relocation, ventura:       "ce114a13425cde927c8f5339da613b7ade8c53a635880d99d0a8bce3148b6b28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e831d5f17f37ade49c96ef94a6264148d887f4975087793233db86fb6ef156b2"
  end

  depends_on "python@3.13"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "colorlog" do
    url "https:files.pythonhosted.orgpackagesd37a359f4d5df2353f26172b3cc39ea32daa39af8de522205f512f458923e677colorlog-6.9.0.tar.gz"
    sha256 "bfba54a1b93b94f54e1f4fe48395725a3d92fd2a4af702f6bd70946bdc0c6ac2"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesaf92b3130cbbf5591acf9ade8708c365f3238046ac7cb8ccba6e81abccb0ccffjinja2-3.1.5.tar.gz"
    sha256 "8fefff8dc3034e27bb80d67c671eb8a9bc424c0ef4c0826edbff304cceff43bb"
  end

  resource "lxml" do
    url "https:files.pythonhosted.orgpackagese76b20c3a4b24751377aaa6307eb230b66701024012c29dd374999cc92983269lxml-5.3.0.tar.gz"
    sha256 "4e109ca30d1edec1ac60cdbe341905dc3b8f55b16855e03a54aaf59e51ec8c6f"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackagesb2975d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages8e628336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath"example.c").write "int main() { return 0; }"
    system ENV.cc, "-fprofile-arcs", "-ftest-coverage", "-fPIC", "-O0", "-o",
                   "example", "example.c"
    assert_match "Code Coverage Report", shell_output("#{bin}gcovr -r .")
  end
end