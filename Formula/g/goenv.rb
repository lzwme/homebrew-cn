class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/go-nv/goenv"
  url "https://ghproxy.com/https://github.com/go-nv/goenv/archive/refs/tags/2.1.8.tar.gz"
  sha256 "b0955c3c9f61b737f8d39f6cec41b3d7a7a8e1918712e805ff83fe24f42a783a"
  license "MIT"
  version_scheme 1
  head "https://github.com/go-nv/goenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "00005ba8026b79a8f903235667632e7577cec947ba7243e2994d42e5d36e8fb6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "00005ba8026b79a8f903235667632e7577cec947ba7243e2994d42e5d36e8fb6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00005ba8026b79a8f903235667632e7577cec947ba7243e2994d42e5d36e8fb6"
    sha256 cellar: :any_skip_relocation, sonoma:         "8726759faacd64e40a94411635c9608b8fb80b05b0bce0d9b6a717900006b80d"
    sha256 cellar: :any_skip_relocation, ventura:        "8726759faacd64e40a94411635c9608b8fb80b05b0bce0d9b6a717900006b80d"
    sha256 cellar: :any_skip_relocation, monterey:       "8726759faacd64e40a94411635c9608b8fb80b05b0bce0d9b6a717900006b80d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00005ba8026b79a8f903235667632e7577cec947ba7243e2994d42e5d36e8fb6"
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