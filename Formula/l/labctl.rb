class Labctl < Formula
  desc "CLI tool for interacting with iximiuz labs and playgrounds"
  homepage "https://github.com/iximiuz/labctl"
  url "https://ghfast.top/https://github.com/iximiuz/labctl/archive/refs/tags/v0.1.68.tar.gz"
  sha256 "c80942d61371101824afd5a73669caf600d68cb913371ceb1c72aafdd7e80805"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9d398053ad761335624280c3b598316874088d967c3a84612646211c249c86e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9d398053ad761335624280c3b598316874088d967c3a84612646211c249c86e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9d398053ad761335624280c3b598316874088d967c3a84612646211c249c86e"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0023f94f14980649b1d7f0cc006e8868a05ee7896dbd7c470c296763e9594b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6ea3556eb736732698bb166a2c0b9f89596131b97321edead6416bcce699098"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d7a8bd435ab9df14fdc91e751395521753d4dcf93702c51a59f844195ea75b6"
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