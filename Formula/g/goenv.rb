class Goenv < Formula
  desc "Go version management"
  homepage "https:github.comgo-nvgoenv"
  url "https:github.comgo-nvgoenvarchiverefstags2.2.1.tar.gz"
  sha256 "a5d1cac799a4cd3d99e0433df90f4307ed08642c42a75c601c5cbc76e4f8ade9"
  license "MIT"
  version_scheme 1
  head "https:github.comgo-nvgoenv.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5358472cc23d05f249539cb6661a2ff7f58ac2d22601ae0e67f3f3fe9860d9dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5358472cc23d05f249539cb6661a2ff7f58ac2d22601ae0e67f3f3fe9860d9dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5358472cc23d05f249539cb6661a2ff7f58ac2d22601ae0e67f3f3fe9860d9dc"
    sha256 cellar: :any_skip_relocation, sonoma:         "50f01ba8fdd2b723d8256d6f56f529f3968c95a925239cca5f753d5e16a03c18"
    sha256 cellar: :any_skip_relocation, ventura:        "50f01ba8fdd2b723d8256d6f56f529f3968c95a925239cca5f753d5e16a03c18"
    sha256 cellar: :any_skip_relocation, monterey:       "50f01ba8fdd2b723d8256d6f56f529f3968c95a925239cca5f753d5e16a03c18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5358472cc23d05f249539cb6661a2ff7f58ac2d22601ae0e67f3f3fe9860d9dc"
  end

  def install
    inreplace_files = [
      "libexecgoenv",
      "pluginsgo-buildinstall.sh",
      "testgoenv.bats",
      "testtest_helper.bash",
    ]
    inreplace inreplace_files, "usrlocal", HOMEBREW_PREFIX

    prefix.install Dir["*"]
    %w[goenv-install goenv-uninstall go-build].each do |cmd|
      bin.install_symlink "#{prefix}pluginsgo-buildbin#{cmd}"
    end
  end

  test do
    assert_match "Usage: goenv <command> [<args>]", shell_output("#{bin}goenv help")
  end
end