class Labctl < Formula
  desc "CLI tool for interacting with iximiuz labs and playgrounds"
  homepage "https://labs.iximiuz.com/playgrounds"
  url "https://ghfast.top/https://github.com/iximiuz/labctl/archive/refs/tags/v0.1.102.tar.gz"
  sha256 "0ad128ed956dcf2fecd36fed907615da18dccf949e014778766b03c37a02fb5d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "04641d610ea19334315a11efa665b3f2820bcf3293fa2c6479c4a318ef8d9f54"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04641d610ea19334315a11efa665b3f2820bcf3293fa2c6479c4a318ef8d9f54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04641d610ea19334315a11efa665b3f2820bcf3293fa2c6479c4a318ef8d9f54"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fe2d59b43d33fdafe6c57bb8fcc1af5a5f4690fa541f795684feb87123d4e2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1c12dab4a4b88f0648e46598e679cfc8df660556c5ebd2e3d96895a0071eef7"
    sha256 cellar: :any,                 x86_64_linux:  "62d195f9c9c502c56359ab3dc8a7d4d38d74885dc4ac3ee5db8d5e1e17e66427"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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