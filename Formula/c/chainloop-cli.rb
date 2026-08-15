class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.106.0.tar.gz"
  sha256 "a8815c6f85503eaacff1d23b9da6aa671620d13c414c30a90e0f16e75124bb69"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "972ba34fa7e6acbbeace49f4724cf6677f27f0d16b885bc94908b54dac6ef3ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "972ba34fa7e6acbbeace49f4724cf6677f27f0d16b885bc94908b54dac6ef3ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "972ba34fa7e6acbbeace49f4724cf6677f27f0d16b885bc94908b54dac6ef3ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb0b36803f8297b0a9a7e3de76d1f4f14901b4393d610e6b19051fdace3ebacf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e29e8561580129d17d3643c9bb41f87e13f11dcd28b038c8ef5c7edec7cbf40b"
    sha256 cellar: :any,                 x86_64_linux:  "cd8fad9ecbe7cbd525f3303a1c521763d58a16d0cb77d4f960f5f331452152d9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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