class Goenv < Formula
  desc "Go version management"
  homepage "https:github.comgo-nvgoenv"
  url "https:github.comgo-nvgoenvarchiverefstags2.2.9.tar.gz"
  sha256 "e49acea81fd6921770911e680f726ef3a167ad708402257ae00c74aba919375c"
  license "MIT"
  version_scheme 1
  head "https:github.comgo-nvgoenv.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75420fab3805c965dc5d9966709ec6186bdfc91171da3e8368b48134f60bd075"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75420fab3805c965dc5d9966709ec6186bdfc91171da3e8368b48134f60bd075"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "75420fab3805c965dc5d9966709ec6186bdfc91171da3e8368b48134f60bd075"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e9fcb6dca6fa12757c721cf5e0037e123a4db6b4992b90519dfc249ef3126da"
    sha256 cellar: :any_skip_relocation, ventura:       "5e9fcb6dca6fa12757c721cf5e0037e123a4db6b4992b90519dfc249ef3126da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75420fab3805c965dc5d9966709ec6186bdfc91171da3e8368b48134f60bd075"
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