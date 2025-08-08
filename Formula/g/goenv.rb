class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/go-nv/goenv"
  url "https://ghfast.top/https://github.com/go-nv/goenv/archive/refs/tags/2.2.27.tar.gz"
  sha256 "25aeb49c66389a736b7c15f5e726d9d13d81ddb9ba943a6763ac9cba184357a8"
  license "MIT"
  version_scheme 1
  head "https://github.com/go-nv/goenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "317b2ec4ffcdd1db9eac672a8693dcc529533735e91b05b19323bd8d19675696"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "317b2ec4ffcdd1db9eac672a8693dcc529533735e91b05b19323bd8d19675696"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "317b2ec4ffcdd1db9eac672a8693dcc529533735e91b05b19323bd8d19675696"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e4ce60ae4f67728a765ca9a869267e5b9378dce15fde0b7f8442e2aa0802ebf"
    sha256 cellar: :any_skip_relocation, ventura:       "4e4ce60ae4f67728a765ca9a869267e5b9378dce15fde0b7f8442e2aa0802ebf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "317b2ec4ffcdd1db9eac672a8693dcc529533735e91b05b19323bd8d19675696"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "317b2ec4ffcdd1db9eac672a8693dcc529533735e91b05b19323bd8d19675696"
  end

  def install
    inreplace_files = [
      "libexec/goenv",
      "plugins/go-build/install.sh",
      "test/goenv.bats",
      "test/test_helper.bash",
    ]
    inreplace inreplace_files, "/usr/local", HOMEBREW_PREFIX

    prefix.install Dir["*"]
    %w[goenv-install goenv-uninstall go-build].each do |cmd|
      bin.install_symlink "#{prefix}/plugins/go-build/bin/#{cmd}"
    end
  end

  test do
    assert_match "Usage: goenv <command> [<args>]", shell_output("#{bin}/goenv help")
  end
end