class Pvetui < Formula
  desc "Terminal UI for Proxmox VE"
  homepage "https://github.com/devnullvoid/pvetui"
  url "https://ghfast.top/https://github.com/devnullvoid/pvetui/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "0b38df0e11befcb07a383a0f41fd5c5e42639e01677394078bbff3632f218489"
  license "MIT"
  head "https://github.com/devnullvoid/pvetui.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7febe2d130435faf143106f593c6db41101ea64481f90c72297e8abb7fffe8d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7febe2d130435faf143106f593c6db41101ea64481f90c72297e8abb7fffe8d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7febe2d130435faf143106f593c6db41101ea64481f90c72297e8abb7fffe8d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b6c2cbc557d489a2f9e888ab3195e5dde9b5ac4ae4b3aed54fa7bc0d6e19b23"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "307b155516f4e32afba4aac0ac2054552b508354366c8950b90ae6d6772756ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e11c7264b5f75ddaa45301d29d9fc936193ac20248b8141fa8407548b4b755cc"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/devnullvoid/pvetui/internal/version.version=#{version}
      -X github.com/devnullvoid/pvetui/internal/version.commit=#{tap.user}
      -X github.com/devnullvoid/pvetui/internal/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/pvetui"
  end

  test do
    assert_match "It looks like this is your first time running pvetui.", pipe_output(bin/"pvetui", "n")
    assert_match version.to_s, shell_output("#{bin}/pvetui --version")
  end
end