class Pvetui < Formula
  desc "Terminal UI for Proxmox VE"
  homepage "https://github.com/devnullvoid/pvetui"
  url "https://ghfast.top/https://github.com/devnullvoid/pvetui/archive/refs/tags/v1.0.17.tar.gz"
  sha256 "6e5002a3ea2db0906a9b8bf5861c8a5b30dc31274c151833147c7438015b38d7"
  license "MIT"
  head "https://github.com/devnullvoid/pvetui.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b7e06f600ee2d65be1058abb7a6c5e6a5846780afd3d5aee1f666d14f1e48bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b7e06f600ee2d65be1058abb7a6c5e6a5846780afd3d5aee1f666d14f1e48bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b7e06f600ee2d65be1058abb7a6c5e6a5846780afd3d5aee1f666d14f1e48bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "820346bec86f87de4965481a1d367c13d8886ff0d0ccd92555ee8c6c2760c7ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f26db8e65a26a3260bbd33279bcfac9ca7116930552d36b49a179c567f83b18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0db301b0155cf915af41b107b2332dbbb454157d746ab85f10df5bb34186364"
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