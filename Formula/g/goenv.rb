class Goenv < Formula
  desc "Go version management"
  homepage "https:github.comgo-nvgoenv"
  url "https:github.comgo-nvgoenvarchiverefstags2.2.5.tar.gz"
  sha256 "f310b3a33407d01779e74c4d3ab934fe20a17549c83d88aa0c059dba78d8b526"
  license "MIT"
  version_scheme 1
  head "https:github.comgo-nvgoenv.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "da95597e5861adfe4ca3e036318514fb506c3ede13398fef4cc1466f980c0ca0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da95597e5861adfe4ca3e036318514fb506c3ede13398fef4cc1466f980c0ca0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da95597e5861adfe4ca3e036318514fb506c3ede13398fef4cc1466f980c0ca0"
    sha256 cellar: :any_skip_relocation, sonoma:         "1b358202e028e4cfdd541f2bb88dd73d56fef0e9298d550bc1b6beb7670e3d80"
    sha256 cellar: :any_skip_relocation, ventura:        "1b358202e028e4cfdd541f2bb88dd73d56fef0e9298d550bc1b6beb7670e3d80"
    sha256 cellar: :any_skip_relocation, monterey:       "1b358202e028e4cfdd541f2bb88dd73d56fef0e9298d550bc1b6beb7670e3d80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da95597e5861adfe4ca3e036318514fb506c3ede13398fef4cc1466f980c0ca0"
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