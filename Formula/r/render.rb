class Render < Formula
  desc "Command-line interface for Render"
  homepage "https://render.com/docs/cli"
  url "https://ghfast.top/https://github.com/render-oss/cli/archive/refs/tags/v2.25.0.tar.gz"
  sha256 "95989223db95ee484aa653130a20f92ea136b6a80af6aa5de1fd5beafd07f563"
  license "Apache-2.0"
  head "https://github.com/render-oss/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0dec9512b9d9514ac84c5cdd2eda6c2650b15f4436efa715098e6688b128e2f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0dec9512b9d9514ac84c5cdd2eda6c2650b15f4436efa715098e6688b128e2f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0dec9512b9d9514ac84c5cdd2eda6c2650b15f4436efa715098e6688b128e2f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52d505abd19fcea46efb8498802152e25b895574e8ee51076bc22ba124eb2133"
    sha256 cellar: :any,                 x86_64_linux:  "962192f62330bf5cb934542f87bbb05f794a25b920e1a089d4f1ff788bdd0c1f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-X github.com/render-oss/cli/pkg/cfg.Version=#{version}]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/render --version")

    output = shell_output("#{bin}/render services -o json 2>&1", 1)
    assert_match "Error: no workspace set. Use `render workspace set` to set a workspace", output
  end
end