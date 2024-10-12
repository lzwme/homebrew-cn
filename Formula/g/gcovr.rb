class Gcovr < Formula
  include Language::Python::Virtualenv

  desc "Reports from gcov test coverage program"
  homepage "https:gcovr.com"
  url "https:files.pythonhosted.orgpackages42198a72c830ab7aed71927606c6432f7edded6cd214639dc07f610e8e22496agcovr-8.0.tar.gz"
  sha256 "3d91ef6df6c465bab91a5b12c82c481b0fbe841d64630dcbf76a0faac7e994e8"
  license "BSD-3-Clause"
  head "https:github.comgcovrgcovr.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41649757986ac29778dae491b0bd88443228043cec84a4a682dda80de7b673f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09c9bb5d0fbff3ca778759453d182471a65170f155cf2e1c36d1dc7d51360164"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e0a1ebccb2e60920ed4868fa40f0f2d8d580a21bc746d4776fb02e861fe0e4cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "69da6b03075d8610694fc229768d823a921b614991fa501646904d910f5bca47"
    sha256 cellar: :any_skip_relocation, ventura:       "8d0e9ed49b4b276aa68cc5d82a52f78806762814d504a5c7b67d06300a6f4c18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8338d43f214b48f4321af78183d163fe2ebfad7850d6f8d60d86597f717fc6b2"
  end

  depends_on "python@3.13"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "colorlog" do
    url "https:files.pythonhosted.orgpackagesdb382992ff192eaa7dd5a793f8b6570d6bbe887c4fbbf7e72702eb0a693a01c8colorlog-6.8.2.tar.gz"
    sha256 "3e3e079a41feb5a1b64f978b5ea4f46040a94f11f0e8bbb8261e3dbbeca64d44"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesed5539036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5djinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
  end

  resource "lxml" do
    url "https:files.pythonhosted.orgpackagese76b20c3a4b24751377aaa6307eb230b66701024012c29dd374999cc92983269lxml-5.3.0.tar.gz"
    sha256 "4e109ca30d1edec1ac60cdbe341905dc3b8f55b16855e03a54aaf59e51ec8c6f"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackagesb4d238ff920762f2247c3af5cbbbbc40756f575d9692d381d7c520f45deb9b8fmarkupsafe-3.0.1.tar.gz"
    sha256 "3e683ee4f5d0fa2dde4db77ed8dd8a876686e3fc417655c2ece9a90576905344"
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