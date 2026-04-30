class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.17.2.tar.gz"
  sha256 "9619360a3f8200e2b0658aad6b42ba5577093ab690b9cb1a2ca5b4985ea42756"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "347ed78350864c0d7b5ccbfe0c915e3ab128109a98716dcab1bee9e8b0db6038"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "951676e73e7d90b559ffb8b05cab915f10ed7114f6be36801d9eaf215608e0f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32f891d3892367a72f50222e163fd22fbf4557abb7feddc4ba9a3bf7042d1f34"
    sha256 cellar: :any_skip_relocation, sonoma:        "6718f70129378e5c9e7bd072a7c0cd4796388bba47216ae17607d76dbefafe14"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a9aec989158bcf509f3e786c2b41fd8c52a0449beb05db20cfecff39e052aa7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4fee92117e5dc05ad688b516753f8991606d0e61a095b9bd9419d53fba75e56"
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