class Goat < Formula
  desc "General purpose AT Protocol CLI in Go"
  homepage "https://github.com/bluesky-social/goat"
  url "https://github.com/bluesky-social/goat.git",
      tag:      "v0.2.0",
      revision: "c43d54adc1c155fdd3a1ac59ecb90d5430ece3cc"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0daf8450fc323ca519c18ac54517ff292945bacbf03fb24305934f2cb30c54d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e54bcd0cfeff0b1f987d2e5355473a5e9051012a4e86b5ce69509cc4a7e97b6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5458d4b4129a9a86a81759f741e94619a4a4b2606ecc7e378cae01bacceb076"
    sha256 cellar: :any_skip_relocation, sonoma:        "36ad743425d13442e3e01e74471830abd037ad68cec8d9717cfc2ffa51401710"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "727999da16263702a2af63634cf4402f896ca504fd9e5720fecdc6e63ffa2af7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e36174bac9240636ce4f41a7e88fee4273c1bd244e9d4736492b7d24c88a4a1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goat --version")

    output = shell_output("#{bin}/goat get at://atproto.com/app.bsky.actor.profile/self")
    assert_match "Social networking technology created by Bluesky.", output
    assert_match "\"displayName\": \"AT Protocol Developers\"", output
  end
end