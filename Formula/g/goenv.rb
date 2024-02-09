class Goenv < Formula
  desc "Go version management"
  homepage "https:github.comgo-nvgoenv"
  url "https:github.comgo-nvgoenvarchiverefstags2.1.12.tar.gz"
  sha256 "7515ecd5bae75309b1b00e6ce9e238b8e9603b186a900cdd9bba3609527e68ad"
  license "MIT"
  version_scheme 1
  head "https:github.comgo-nvgoenv.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b20ef093540d7161512ee5cc6bd57c4a125f5c4b8dfd6f3bbbab4900efed5bdc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b20ef093540d7161512ee5cc6bd57c4a125f5c4b8dfd6f3bbbab4900efed5bdc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b20ef093540d7161512ee5cc6bd57c4a125f5c4b8dfd6f3bbbab4900efed5bdc"
    sha256 cellar: :any_skip_relocation, sonoma:         "3b636dc18ee675c373e151edfb8d11a2e2eb0cb5276481018870a5c111c5792d"
    sha256 cellar: :any_skip_relocation, ventura:        "3b636dc18ee675c373e151edfb8d11a2e2eb0cb5276481018870a5c111c5792d"
    sha256 cellar: :any_skip_relocation, monterey:       "3b636dc18ee675c373e151edfb8d11a2e2eb0cb5276481018870a5c111c5792d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b20ef093540d7161512ee5cc6bd57c4a125f5c4b8dfd6f3bbbab4900efed5bdc"
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