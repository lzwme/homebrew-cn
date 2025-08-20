class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.293.tar.gz"
  sha256 "ce2084e705d7b7a0bcf83d1397a25111b91330f2b1fe3c5a8717f9f947175c28"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f93d3d2614ea799d704b1d471e4c9683d72c73e53bb8598da0d3a606417bbc39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f93d3d2614ea799d704b1d471e4c9683d72c73e53bb8598da0d3a606417bbc39"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f93d3d2614ea799d704b1d471e4c9683d72c73e53bb8598da0d3a606417bbc39"
    sha256 cellar: :any_skip_relocation, sonoma:        "88f03d8dc2ccb6d150c6d7aa1d24d52762d882981292cda75cab155b8ea291db"
    sha256 cellar: :any_skip_relocation, ventura:       "88f03d8dc2ccb6d150c6d7aa1d24d52762d882981292cda75cab155b8ea291db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96852a012da1b98526204177e79f0007e3561118c84221b837c46eab41eab650"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/fabric"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fabric-ai --version")

    (testpath/".config/fabric/.env").write("t\n")
    output = pipe_output("#{bin}/fabric-ai --dry-run 2>&1", "", 1)
    assert_match "error loading .env file: unexpected character", output
  end
end