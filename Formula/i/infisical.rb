class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.74.tar.gz"
  sha256 "f297ea9402c25b9da29a34de89c7fe405ffd84438fb88c77090d4c4e21bfa519"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f60d124e279850116add608db8be565a26dfcf05342a16b41ee1ba2490a99c1c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f60d124e279850116add608db8be565a26dfcf05342a16b41ee1ba2490a99c1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f60d124e279850116add608db8be565a26dfcf05342a16b41ee1ba2490a99c1c"
    sha256 cellar: :any_skip_relocation, sonoma:        "03259fd9aaffb27863de54fd799179253c26424d4bfdf9e4d2e1cd8528e4d61c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c5b9250a0e6fda0b1ba1221e92e48f8fdd5725285a5a8bebb6cc6b20e4bdc37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da921455548e08807988c52ee36aaac5384de269c4518e4ffed9c3235792f946"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"infisical", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/infisical --version")

    output = shell_output("#{bin}/infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}/infisical agent 2>&1")
    assert_match "starting Infisical agent", output
  end
end