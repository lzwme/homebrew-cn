class Labctl < Formula
  desc "CLI tool for interacting with iximiuz labs and playgrounds"
  homepage "https://labs.iximiuz.com/playgrounds"
  url "https://ghfast.top/https://github.com/iximiuz/labctl/archive/refs/tags/v0.1.109.tar.gz"
  sha256 "56cf54c4630cda92bd6608ac3648b8fd67aabecab18510aa03773a21137515f6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "55b30b3bc7334669b6cde98215921c3f4a178652f792a835af135ba6c49d2110"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55b30b3bc7334669b6cde98215921c3f4a178652f792a835af135ba6c49d2110"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55b30b3bc7334669b6cde98215921c3f4a178652f792a835af135ba6c49d2110"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08b389af3f76585c891400a3ab5f47e5c7b6d82fbfc293efc81cb8067946c14a"
    sha256 cellar: :any,                 x86_64_linux:  "459b3b280ec267a7c0163466b80ed411455da8329c3bdf3797df45b8bef83de3"
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