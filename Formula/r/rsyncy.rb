class Rsyncy < Formula
  include Language::Python::Virtualenv

  desc "Statusprogress bar for rsync"
  homepage "https:github.comlaktakrsyncy"
  url "https:github.comlaktakrsyncyarchiverefstagsv0.2.0.tar.gz"
  sha256 "35b8998e5ff13edd5ea833fcb8b837013424d86c3110091028d3ca71cdd46bde"
  license "MIT"
  head "https:github.comlaktakrsyncy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b06ca4e03ad3b2fd440f66796c66d7517fc9986116fb0a593419a9a6406c054e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ada840c1a9d37e461ab1efb7e14e322ff66ead0d11c02fb574506a5641e1eaf9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d35b916b3e49fdcc163f3a510fb139bf87dac752925a59369dbac2b3366b464"
    sha256 cellar: :any_skip_relocation, sonoma:         "dc258d8cfb7472db3817800e8c9853d1c4f759e483295edb9c6f1f27d4c09bac"
    sha256 cellar: :any_skip_relocation, ventura:        "7a5f75e58fb7e959f28ca487c07f25ec2b4c712ffc9b54d86e081f5dc1fffac8"
    sha256 cellar: :any_skip_relocation, monterey:       "37ce7f450e47daa9a5519532bcec1e0dfedd88763c11dbf8661f67fc6f222ee3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da2fc3f586b2b0236b95e33b4b31936e3f14f62355ebd118f03b9af6610337af"
  end

  depends_on "python@3.12"
  depends_on "rsync"

  uses_from_macos "zlib"

  def install
    virtualenv_install_with_resources
  end

  test do
    # rsyncy is a wrapper, rsyncy --version will invoke it and show rsync output
    assert_match(.*rsync.+version.*, shell_output("#{bin}rsyncy --version"))

    # test copy operation
    mkdir testpath"a" do
      mkdir "foo"
      (testpath"afooone.txt").write <<~EOS
        testing
        testing
        testing
      EOS
      system bin"rsyncy", "-r", testpath"afoo", testpath"abar"
      assert_predicate testpath"abarone.txt", :exist?
    end
  end
end