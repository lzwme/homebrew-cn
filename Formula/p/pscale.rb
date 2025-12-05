class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://ghfast.top/https://github.com/planetscale/cli/archive/refs/tags/v0.265.0.tar.gz"
  sha256 "35d5007b2425be9de891495e164c281a4956abe525d73f63b9e89b9e1a14306e"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a42e6cb261b4c63f7a0504d8a8dee950a5455b9c6702b2e615888e39f37abccb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70e57fb4027ef9a3c79abc34e6b3dab452788ee0ea70c639674d2d2644fb1249"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39c2594dbf253058dacc2e6bfbd58e94ca03b2b7d55c86d9cb36ce44a494a5d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "157dfd0ae2e69d4968848ae51c575dd77c953f5b543aac1397057e5f646574c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4df63d42c038d65b7dcf61c08e754904ae9e1c1764f103a188570c1297f0874"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12cef9cb0b2cf8dec45126e0a91e29e71c0ffd71bac968f3cf39ca72d028dde6"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/pscale"

    generate_completions_from_executable(bin/"pscale", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pscale version")

    assert_match "Error: not authenticated yet", shell_output("#{bin}/pscale org list 2>&1", 2)
  end
end