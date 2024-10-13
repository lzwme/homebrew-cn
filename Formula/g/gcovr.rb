class Gcovr < Formula
  include Language::Python::Virtualenv

  desc "Reports from gcov test coverage program"
  homepage "https:gcovr.com"
  url "https:files.pythonhosted.orgpackagesa0394cef4a5bc70dbf625b3c0dfc4fe675d24bca570e72b3b2a371761471baa5gcovr-8.1.tar.gz"
  sha256 "6a07a15bdfdc200af1960932792012e4e26c239c8a9f585b60d1b46d072ca439"
  license "BSD-3-Clause"
  head "https:github.comgcovrgcovr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fbb2f5451e7b3f7979e95e99c93adb89b871c2462f5b3e2b7ccc8ffaefceb843"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c16090ce2ae4ddb4a703d370fd1fecac71128c9bff8d3e7cb8a6159f6b0ad28f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "343206a5ba7414d9030eedf7042fd4ebd31911eecb87f79f42697a8d184714b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "13855533230c000d29e8e6e0c46afea8a2b90a61d45e588da05e28b602dc6279"
    sha256 cellar: :any_skip_relocation, ventura:       "814dad51f9bc7137c8472711d2641c815abeedde3d544c8b3bdcbe8c1f4afda6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b0d81b770f4c989df9812a5097d441415f4d68229633492ff617349bab723eb"
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