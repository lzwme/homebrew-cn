class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.11.27.tar.gz"
  sha256 "adb406139622c1f3dedf14e8036843c4d34d99ba7ed8f8a4f5cd7edba582cdc0"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2c7b3449ac2fe1d2a0049a84b5d915828d552158f80bba91b924adf7ff39aca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "616a186f7c97b25f292d55b6f3d306c224ce2714cb1e4bb652357bacb3a1dbf2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0320bb6c9b80a07b4833f9432d20936d09ea13e11f91de7b9b0eb2cea95d5eb6"
    sha256 cellar: :any_skip_relocation, sonoma:        "81eb79459c57a77439e76a6776127846fe6311d96b4b8f82c49e265cf7f0bd6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c001310396c417d9f62f3b87982c4e55cde8b94963c55ee00d64343052caa950"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ca16fd1e5d30f2de9e557e417e76a109ba374c98922baab27e3953ebcaf21ce"
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

    generate_completions_from_executable(bin/"kosli", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end