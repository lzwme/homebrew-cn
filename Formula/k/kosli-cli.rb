class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.26.0.tar.gz"
  sha256 "cabb08645abb6c0dadf39fda397835e74a1ee37885fd86b4481ccc693ceb6f60"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "406a56b243ed21baf48e7e5a17ecee68f905d43c6998dc989bae1d330fd4a8a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7d63a3e61fa8fd5bfc7788c4d0760d5857072ea73e3ee150b98720e39b51239"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59b4abec25266541e8ad49bf3a2a27558569a89561fa65bc8b3d9915bd2e4970"
    sha256 cellar: :any_skip_relocation, sonoma:        "c31ef6564f6e209aa2a88a5bf4eba4217524ab3b9efc0dc1c80fccd95e3af09f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6fe45670e4982a17d62d778b7188b28a09426ed41e513d8ce23d566d9ce5ce9b"
    sha256 cellar: :any,                 x86_64_linux:  "bbbb6a249e4f76d284da890534ea2956633050fb4ac920ec893ebb511240deed"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/kosli-dev/cli/internal/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin/"kosli", ldflags:), "./cmd/kosli"

    generate_completions_from_executable(bin/"kosli", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end