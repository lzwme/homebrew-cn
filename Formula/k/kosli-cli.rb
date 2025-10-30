class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.11.28.tar.gz"
  sha256 "c54f9be9cc9dae665779fa4cb4caedb447f1d8384b85554c75fa49a66a9e0788"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b63c532bdbbd98ad916668d64896b8c3450326d40467b09863e70b0df6b59d35"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0933f3d256c755f227d96a8e37146e76fb49cf75d36950d02a7e41490107e647"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b51a7063c160fa59232b8d7e67b7885f183e961ea0127e0440b17716ec5e86e"
    sha256 cellar: :any_skip_relocation, sonoma:        "404f1dcae5658beb3926b8c1f2dfa598286145d16df34dfebac50662fe9effb4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "280fbaa71fb34d119bcca8a740f4dca62b0f91c83d79bf9dbd53ecadd9671c59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18dfa45c4553cc6fc5c4dbf43b93809a16cc00daa6068f2bf3e2bbb6ce8d4633"
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