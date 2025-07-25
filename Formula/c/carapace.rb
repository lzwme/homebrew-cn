class Carapace < Formula
  desc "Multi-shell multi-command argument completer"
  homepage "https://carapace.sh"
  url "https://ghfast.top/https://github.com/carapace-sh/carapace-bin/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "7460eef0ea7d19e5d0082e425fbef08f506d926d995701c7a8c3c6e90c9e61c5"
  license "MIT"
  head "https://github.com/carapace-sh/carapace-bin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd0b1905afce3324801a0cc8861a6097ac068b5cfe06c8f28a9fe97dc30fbf1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d29466853838fa6b09fb6eac678aa463317787c8a29621d07bfe91a72dcbafaf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b82a756d84ab02124a78edcac33d9cb409dc423eb204e1e3b5aab306007c8ed8"
    sha256 cellar: :any_skip_relocation, sonoma:        "1102e5429e8062300db6b369f1a1e043347fe954874c78acc5490193b8f61c3b"
    sha256 cellar: :any_skip_relocation, ventura:       "3324d1e2b86f2e23434ae154f718a58b3481ccd71ec5e9ca21e1defbd5ca28cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "111c3aeb5a3c91fc3cc4f6dec11089152474986645fbf68b9c9f084ce8cdf298"
  end

  depends_on "go" => :build

  def install
    system "go", "generate", "./..."
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "release"), "./cmd/carapace"

    generate_completions_from_executable(bin/"carapace", "_carapace")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/carapace --version 2>&1")

    system bin/"carapace", "--list"
    system bin/"carapace", "--macro", "color.HexColors"
  end
end