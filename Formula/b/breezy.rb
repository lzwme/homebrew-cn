class Breezy < Formula
  include Language::Python::Virtualenv

  desc "Version control system implemented in Python with multi-format support"
  # homepage "https://www.breezy-vcs.org/" # https://bugs.launchpad.net/brz/+bug/2102204
  homepage "https://github.com/breezy-team/breezy"
  # pypi sdist bug report, https://bugs.launchpad.net/brz/+bug/2111649
  url "https://ghfast.top/https://github.com/breezy-team/breezy/archive/refs/tags/brz-3.3.15.tar.gz"
  sha256 "0a6353b9e42eace08abb59c2cd29e5f705d24e417abe8e2b8fc984623595b5b4"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^brz[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d644bef18f857c66c3276871b2a0980c308b290bd312e9c875e6c3073e52b3aa"
    sha256 cellar: :any,                 arm64_sequoia: "2cc6f4892d23e975a07fe3a3635063aa65af1da5911fa276ffaf26d8a45d9a78"
    sha256 cellar: :any,                 arm64_sonoma:  "de01f3dfd6d97c8bfe19706ed4785c89447e2c2e78dc458d9e00dc72eab9084d"
    sha256 cellar: :any,                 sonoma:        "493fd0c7cbb17032800f5f2465421d06e4f304580bcd4c555f4658a5f0bb66bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99eeea3bd9ab6bb9adeab180a0972a75a4919d4e481408314e9e2e1717142732"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ec3f8422259f634b4609cb06ffd5f9f4e446366e1fb0cb5992c046273ff6fb4"
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
    url "https://files.pythonhosted.org/packages/2b/f3/13a3425ddf04bd31f1caf3f4fa8de2352700c454cb0536ce3f4dbdc57a81/dulwich-0.24.1.tar.gz"
    sha256 "e19fd864f10f02bb834bb86167d92dcca1c228451b04458761fc13dabd447758"
  end

  resource "fastbencode" do
    url "https://files.pythonhosted.org/packages/cd/e5/0e98b0154da2705852a1154a4d325830583670c376a6c46e9f557b0aa3c5/fastbencode-0.3.6.tar.gz"
    sha256 "114f853ebbb0a5168ac7ca4337bd9a542105e3d403b970111bfef16e0037c1c5"
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
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  def install
    virtualenv_install_with_resources
    bin.each_child do |f|
      f.unlink
      f.write_env_script libexec/"bin"/f.basename, PATH: "#{libexec}/bin:$PATH"
    end
    man1.install_symlink Dir[libexec/"man/man1/*.1"]

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