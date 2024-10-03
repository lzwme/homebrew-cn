class Goenv < Formula
  desc "Go version management"
  homepage "https:github.comgo-nvgoenv"
  url "https:github.comgo-nvgoenvarchiverefstags2.2.6.tar.gz"
  sha256 "2b3d7333bda14e272edc0ffcc8751c8bd2cc5bdf23593702cc88f152792f8fe5"
  license "MIT"
  version_scheme 1
  head "https:github.comgo-nvgoenv.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f5e4a1e6818293eb968cf49b4ab229cc6b23991c636c343d1a67635deb6ee25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f5e4a1e6818293eb968cf49b4ab229cc6b23991c636c343d1a67635deb6ee25"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3f5e4a1e6818293eb968cf49b4ab229cc6b23991c636c343d1a67635deb6ee25"
    sha256 cellar: :any_skip_relocation, sonoma:        "2674f72213dc8c9bee0f4ecb9464d4b39fbf5572159ccce30afbb2849912f399"
    sha256 cellar: :any_skip_relocation, ventura:       "2674f72213dc8c9bee0f4ecb9464d4b39fbf5572159ccce30afbb2849912f399"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f5e4a1e6818293eb968cf49b4ab229cc6b23991c636c343d1a67635deb6ee25"
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