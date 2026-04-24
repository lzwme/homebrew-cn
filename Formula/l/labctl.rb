class Labctl < Formula
  desc "CLI tool for interacting with iximiuz labs and playgrounds"
  homepage "https://github.com/iximiuz/labctl"
  url "https://ghfast.top/https://github.com/iximiuz/labctl/archive/refs/tags/v0.1.74.tar.gz"
  sha256 "699c31961a474238fbef1736ac2bd8a280755635cd3bb82547e419ed3c1f0b3e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d55720e890194baaa34ab0b77b13000bfd77fcf40afe053f9825d2204142fc1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d55720e890194baaa34ab0b77b13000bfd77fcf40afe053f9825d2204142fc1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d55720e890194baaa34ab0b77b13000bfd77fcf40afe053f9825d2204142fc1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd56a3dd884a816a20846c698bafdd822db7615b86c10ab7d197f6651aa564a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5970615c6fc55f0efbe67db3e7c1a718ec959b2f115c5c7a2c530b04ca68417"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50ae51a1d677f4ecca917421d014519e8f7280ba4eb5fb9351a11f86e06c911a"
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