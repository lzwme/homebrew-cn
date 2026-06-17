class Labctl < Formula
  desc "CLI tool for interacting with iximiuz labs and playgrounds"
  homepage "https://labs.iximiuz.com/playgrounds"
  url "https://ghfast.top/https://github.com/iximiuz/labctl/archive/refs/tags/v0.1.89.tar.gz"
  sha256 "7d7fa5049ca7438ee8a8c6ae3b6c0fb8a72c02414fdb4919b7980f2b759daed2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c3f3644196f49e997f0fbd145ce245b9be03dff99c5aa5841203a347d3f0d32"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c3f3644196f49e997f0fbd145ce245b9be03dff99c5aa5841203a347d3f0d32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c3f3644196f49e997f0fbd145ce245b9be03dff99c5aa5841203a347d3f0d32"
    sha256 cellar: :any_skip_relocation, sonoma:        "a26772abbd396dd880be809565663a847248eeb20fb74c7565a37c927d545c24"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d15f44fa37b43d174d2bada92111c12ec1efa7203c21b176620d31bd116fc8b9"
    sha256 cellar: :any,                 x86_64_linux:  "162609a40fc690a1434a4dbde4ed2388deaee5da3d93c5242ec293ef5c174571"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/labctl --version")

    assert_match "Not logged in.", shell_output("#{bin}/labctl auth whoami 2>&1")
    assert_match "authentication required.", shell_output("#{bin}/labctl playground list 2>&1", 1)
  end
end