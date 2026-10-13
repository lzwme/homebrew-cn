class Goat < Formula
  desc "General purpose AT Protocol CLI in Go"
  homepage "https://github.com/bluesky-social/goat"
  url "https://ghfast.top/https://github.com/bluesky-social/goat/archive/refs/tags/v0.2.6.tar.gz"
  sha256 "9e9128e7ebec1cf509b138f6d4809e7b93f9d29a0d9b724e0faa93b17bd11e2f"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "70aed9ca116e0b772a9a1c0ed9b60cd6a722f05d46912ea48f3635000634aede"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "92bff82ca06bd019b6bdc6b790977b1c16c7202d1290d21a98e427e80bb21140"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e41b0242c7eebdd8b10388ddc9b6d9a7bf36899ffd57c8d92fabde37fde362b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1ee89f9139cf1021e1572b669b5c47a50acbfd69f85d22609f8a80faae230259"
    sha256 cellar: :any,                 x86_64_linux:      "26f814f28f8f29942a0f731fd90ee872ccacd28da4bf96eaa0517791c9dee79b"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goat --version")

    output = shell_output("#{bin}/goat get at://atproto.com/app.bsky.actor.profile/self")
    assert_match "Social networking technology created by Bluesky.", output
    assert_match "\"displayName\": \"AT Protocol Developers\"", output
  end
end