class Pvetui < Formula
  desc "Terminal UI for Proxmox VE"
  homepage "https://github.com/devnullvoid/pvetui"
  url "https://ghfast.top/https://github.com/devnullvoid/pvetui/archive/refs/tags/v1.0.19.tar.gz"
  sha256 "361946962a5b7ab70bb7c5983b96e762ece507c623b4d50e728a58ac639d3551"
  license "MIT"
  head "https://github.com/devnullvoid/pvetui.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8125b355d79f56aeee66f463bef1eac8d81a6394c38b601adba43cd7cbdc024a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8125b355d79f56aeee66f463bef1eac8d81a6394c38b601adba43cd7cbdc024a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8125b355d79f56aeee66f463bef1eac8d81a6394c38b601adba43cd7cbdc024a"
    sha256 cellar: :any_skip_relocation, sonoma:        "9abeea182abdd5b052b599d6f785dd5f25d87db5cd2586e58a1a7549a37791ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0db494bba9bc90412af5e613bf2398f819d06f396c0a0ec1211634d52720b2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7f5d09220235abfe7a2125e0643780a2e33ba54f59873f1bad3510071bd2916"
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