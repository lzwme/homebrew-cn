class Breezy < Formula
  include Language::Python::Virtualenv

  desc "Version control system implemented in Python with multi-format support"
  # homepage "https:www.breezy-vcs.org" # https:bugs.launchpad.netbrz+bug2102204
  homepage "https:github.combreezy-teambreezy"
  # pypi sdist bug report, https:bugs.launchpad.netbrz+bug2111649
  url "https:github.combreezy-teambreezyarchiverefstagsbrz-3.3.12.tar.gz"
  sha256 "9ce8a3af9f45ea85761bf8a924e719cb5b20dff3e3edb1220b5c99bb37a3e46f"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3e18ef7813d0811d593f237d1abee991c3d1f73bed71aae45c5400d41c1e1391"
    sha256 cellar: :any,                 arm64_sonoma:  "40e9a76731804bdb3db3f8d6251317f12d1ac7f2410e665530c2aa3aca207caf"
    sha256 cellar: :any,                 arm64_ventura: "a0eb5d4f144f1dfc4bf075548c21e6bfe6484d867c2cdaf9c21f910ae7d08717"
    sha256 cellar: :any,                 sonoma:        "b5ecaffeaa63c0d2cae280fd6419435a88eec8744480591ddb81849fb8e749f5"
    sha256 cellar: :any,                 ventura:       "46beb7e5f217a1c856cfca1998fcbbb340dca1b3fe26e19a69615ab369319e36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd65f0409958124bfbbae3f46f5866e75fa37fea5dec6b15ccb376b5eb03d509"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06ba17c48f77f31cacc33015df2c524b909f2620da2e3391d57e646f08f5a65a"
  end

  depends_on "gettext" => :build
  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "configobj" do
    url "https:files.pythonhosted.orgpackagesf5c4c7f9e41bc2e5f8eeae4a08a01c91b2aea3dfab40a3e14b25e87e7db8d501configobj-5.0.9.tar.gz"
    sha256 "03c881bbf23aa07bccf1b837005975993c4ab4427ba57f959afdd9d1a2386848"
  end

  resource "dulwich" do
    url "https:files.pythonhosted.orgpackagesd48b0f2de00c0c0d5881dc39be147ec2918725fb3628deeeb1f27d1c6cf6d9f4dulwich-0.22.8.tar.gz"
    sha256 "701547310415de300269331abe29cb5717aa1ea377af826bf513d0adfb1c209b"
  end

  resource "fastbencode" do
    url "https:files.pythonhosted.orgpackages1d3bb5f553d21eb0c83461a93685eb9784e41516224a6919c1a39a03b3c35715fastbencode-0.3.2.tar.gz"
    sha256 "a34c32c504b0ec9de1a499346ed24932359eb46234b28b70975a50fdfaa14ab5"
  end

  resource "merge3" do
    url "https:files.pythonhosted.orgpackages91e1fe09c161f80b5a8d8ede3270eadedac7e59a64ea1c313b97c386234480c1merge3-0.0.15.tar.gz"
    sha256 "d3eac213d84d56dfc9e39552ac8246c7860a940964ebeed8a8be4422f6492baf"
  end

  resource "patiencediff" do
    url "https:files.pythonhosted.orgpackages1951828577f3b7199fc098d6f440d9af41fbef27067ddd1b60892ad0f9a2d943patiencediff-0.2.15.tar.gz"
    sha256 "d00911efd32e3bc886c222c3a650291440313ee94ac857031da6cc3be7935204"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages8a7816493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  def install
    virtualenv_install_with_resources
    bin.each_child do |f|
      f.unlink
      f.write_env_script libexec"bin"f.basename, PATH: "#{libexec}bin:$PATH"
    end
    man1.install_symlink Dir[libexec"manman1*.1"]

    # Replace bazaar with breezy
    bin.install_symlink "brz" => "bzr"
  end

  test do
    whoami = "Homebrew <homebrew@example.com>"
    system bin"brz", "whoami", whoami
    assert_match whoami, shell_output("#{bin}brz whoami")

    # Test bazaar compatibility
    system bin"brz", "init-repo", "sample"
    system bin"brz", "init", "sampletrunk"
    touch testpath"sampletrunktest.txt"
    cd "sampletrunk" do
      system bin"brz", "add", "test.txt"
      system bin"brz", "commit", "-m", "test"
    end

    # Test git compatibility
    system bin"brz", "init", "--git", "sample2"
    touch testpath"sample2test.txt"
    cd "sample2" do
      system bin"brz", "add", "test.txt"
      system bin"brz", "commit", "-m", "test"
    end
  end
end