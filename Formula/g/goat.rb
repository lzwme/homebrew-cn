class Goat < Formula
  desc "General purpose AT Protocol CLI in Go"
  homepage "https://github.com/bluesky-social/goat"
  url "https://github.com/bluesky-social/goat.git",
      tag:      "v0.2.5",
      revision: "53ba4f937b70be32a89e8cf1b2bd998c8590ceaa"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c88d3e2a220e390734e7ed4a05ade625db9d25bf03348f44155feb0831709079"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1209718599d9db81f42e5e5591b72cf12e49817f5936ca99d42e9babc6fcb4f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "419291f52b38dc496c7175b37b268b852fea477a52562bfed6978077b10e0d87"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0735e22bdb073aecfd488a1c99be705f05c7ce896b9c80714e7a74347716477e"
    sha256 cellar: :any,                 x86_64_linux:      "8b68d1f4e04a4f5c10aec49d13667abe3506cb2f12c6eca92175040b44271197"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goat --version")

    output = shell_output("#{bin}/goat get at://atproto.com/app.bsky.actor.profile/self")
    assert_match "Social networking technology created by Bluesky.", output
    assert_match "\"displayName\": \"AT Protocol Developers\"", output
  end
end