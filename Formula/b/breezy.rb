class Breezy < Formula
  include Language::Python::Virtualenv

  desc "Version control system implemented in Python with multi-format support"
  homepage "https://www.breezy-vcs.org/"
  url "https://files.pythonhosted.org/packages/59/1d/68956e351c1af8116ec8525c85faf82ed2484f38f6f4fed4755759073500/breezy-3.3.21.tar.gz"
  sha256 "70a5a810690ad8d5def1798a1351e7588be7f89f821eb7a6fae277aacd33d3be"
  license "GPL-2.0-or-later"
  revision 2
  head "https://github.com/breezy-team/breezy.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d70657b0dcc78fb47bc19f5c5ab15340ebef7f94e70ab90408308c3505413419"
    sha256 cellar: :any, arm64_sequoia: "57bea812633593d311e11f3797d3e2e5e08f7a662cf2fecda8b24bc901085d50"
    sha256 cellar: :any, arm64_sonoma:  "d3c7e968d4a61af3ece8ee9f55b9d096f74392397b979555643c3fc3a097c687"
    sha256 cellar: :any, sonoma:        "8cb0ec5467bef85f5efc99cd03e02efac56e6a5f2ea9fd6300f450de9bd0d7f6"
    sha256 cellar: :any, arm64_linux:   "3e7158e7a3746767fb16d23795621c80888894a4973f17174a9dd25ba5e525ec"
    sha256 cellar: :any, x86_64_linux:  "d946f2c5587bfe63c8ee8d94ed2ac10f3e913c5cb8e7cb0782323eb74e62e062"
  end

  depends_on "gettext" => :build
  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.14"

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/f5/c4/c7f9e41bc2e5f8eeae4a08a01c91b2aea3dfab40a3e14b25e87e7db8d501/configobj-5.0.9.tar.gz"
    sha256 "03c881bbf23aa07bccf1b837005975993c4ab4427ba57f959afdd9d1a2386848"
  end

  resource "dulwich" do
    url "https://files.pythonhosted.org/packages/43/67/db7dfe7bd7a585e39c938f5f79ccb91235df5f8818f9273590ed6d0f9fdf/dulwich-1.2.4.tar.gz"
    sha256 "72fc77c4e2c7e4358a78c6f71383baceea496ee0cedb13508f52a1a7656e8bb9"
  end

  resource "fastbencode" do
    url "https://files.pythonhosted.org/packages/22/c4/8d3aa6b53dcd74193005ee40632176143b980fccef9235162a0060a30841/fastbencode-0.3.10.tar.gz"
    sha256 "849b6872b6dcbace6f8a7b0c094fc3f5b2ab17aa987e4efb6041293487b360e7"
  end

  resource "merge3" do
    url "https://files.pythonhosted.org/packages/12/71/daaa7978561b9a7bfdcee4ba5ec2ead6162f6a9d2e2edf069def96085c6b/merge3-0.0.16.tar.gz"
    sha256 "0852de4381cb46be5ef4ed49e3ac20c5a4a0cd46a8ff4bbb870bc27aab543306"
  end

  resource "patiencediff" do
    url "https://files.pythonhosted.org/packages/29/42/795991d063200c34094686bd3659a228caa1f4aca1afa98593d06a3d9344/patiencediff-0.2.18.tar.gz"
    sha256 "a678d8252bfb060f1f280fd32d47d917d323e93e1a94ff4ddaaba693a6f66aad"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  def install
    virtualenv_install_with_resources
    bin.each_child do |f|
      f.unlink
      f.write_env_script libexec/"bin"/f.basename, PATH: "#{libexec}/bin:$PATH"
    end

    # Replace bazaar with breezy
    bin.install_symlink "brz" => "bzr"
  end

  test do
    whoami = "Homebrew <homebrew@example.com>"
    system bin/"brz", "whoami", whoami
    assert_match whoami, shell_output("#{bin}/brz whoami")

    # Test bazaar compatibility
    system bin/"brz", "init-repo", "sample"
    system bin/"brz", "init", "sample/trunk"
    touch testpath/"sample/trunk/test.txt"
    cd "sample/trunk" do
      system bin/"brz", "add", "test.txt"
      system bin/"brz", "commit", "-m", "test"
    end

    # Test git compatibility
    system bin/"brz", "init", "--git", "sample2"
    touch testpath/"sample2/test.txt"
    cd "sample2" do
      system bin/"brz", "add", "test.txt"
      system bin/"brz", "commit", "-m", "test"
    end
  end
end