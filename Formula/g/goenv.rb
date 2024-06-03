class Goenv < Formula
  desc "Go version management"
  homepage "https:github.comgo-nvgoenv"
  url "https:github.comgo-nvgoenvarchiverefstags2.1.16.tar.gz"
  sha256 "6d67d3d70c072e25102cb5f2e5a3f5aa93a14098c421a0a509302196492d71b2"
  license "MIT"
  version_scheme 1
  head "https:github.comgo-nvgoenv.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b0f627be909d714d705a4f14799ce1bc7e1d66a99ecb9e2690d0394a984e785f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b0f627be909d714d705a4f14799ce1bc7e1d66a99ecb9e2690d0394a984e785f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0f627be909d714d705a4f14799ce1bc7e1d66a99ecb9e2690d0394a984e785f"
    sha256 cellar: :any_skip_relocation, sonoma:         "6fd8353beb6ea392098dae9c2faefe95ec1bc998b8b248fe929deb1ef2dee453"
    sha256 cellar: :any_skip_relocation, ventura:        "6fd8353beb6ea392098dae9c2faefe95ec1bc998b8b248fe929deb1ef2dee453"
    sha256 cellar: :any_skip_relocation, monterey:       "6fd8353beb6ea392098dae9c2faefe95ec1bc998b8b248fe929deb1ef2dee453"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0f627be909d714d705a4f14799ce1bc7e1d66a99ecb9e2690d0394a984e785f"
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