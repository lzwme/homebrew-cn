class Goenv < Formula
  desc "Go version management"
  homepage "https:github.comgo-nvgoenv"
  url "https:github.comgo-nvgoenvarchiverefstags2.2.20.tar.gz"
  sha256 "19d5891d8540e2c451ab654ea37981a41411fb7dae95fdfe41f8483838b79c4a"
  license "MIT"
  version_scheme 1
  head "https:github.comgo-nvgoenv.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1ae31004a1d84b4f15af508db0b8d0e8ffb6e9b06480619b0ffe9ca0edee734"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1ae31004a1d84b4f15af508db0b8d0e8ffb6e9b06480619b0ffe9ca0edee734"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c1ae31004a1d84b4f15af508db0b8d0e8ffb6e9b06480619b0ffe9ca0edee734"
    sha256 cellar: :any_skip_relocation, sonoma:        "51e229e4eb39cc0c857ec5dc5a4d3427e8ffdcc1da27ca7e7e5c4716f46006bd"
    sha256 cellar: :any_skip_relocation, ventura:       "51e229e4eb39cc0c857ec5dc5a4d3427e8ffdcc1da27ca7e7e5c4716f46006bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1ae31004a1d84b4f15af508db0b8d0e8ffb6e9b06480619b0ffe9ca0edee734"
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