class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.100.8.tar.gz"
  sha256 "e54433d9dfbff6b2f91cf79d308ec4a4f54edc8f85e02d39d7a42a0ae0085282"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fdbd20eeb6f327015b6ba13aaef1e3a33d223fb4d9c76111ab06a3f1b438ecbb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fdbd20eeb6f327015b6ba13aaef1e3a33d223fb4d9c76111ab06a3f1b438ecbb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fdbd20eeb6f327015b6ba13aaef1e3a33d223fb4d9c76111ab06a3f1b438ecbb"
    sha256 cellar: :any_skip_relocation, sonoma:        "1978e5d82da88381949a68634924d8eaaf806cbdeeda715e1322c844eb299239"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8cda078129049062e03e3ed983574dd6a6628d072ec8ae7d90568738a56db168"
    sha256 cellar: :any,                 x86_64_linux:  "b41b15ae44ba29981a00f1074b0a87d4389891308837b95b3d822e50aa0f6bf9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "chainloop auth login", output
  end
end