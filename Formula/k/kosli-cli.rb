class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.11.35.tar.gz"
  sha256 "5449678346daf354399f81e733641f327df761019ab3afd0765bfb45e4154ea5"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f82ebf21124f322bb0f358a7914a88cb0282c903e0b51fc590428c38ed067a07"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61706a10ca23a64c6159845b6ab7b1ac194d1337e7c959a5d763aed779e34c2e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f26f076f961138a11dd8d6ce5d5178ee9c1ddae07990b194e9020c46c314a073"
    sha256 cellar: :any_skip_relocation, sonoma:        "b514dd37c0e406430abdf3eecc336e5a90ea83d87f94e602b71d4187ca1e4138"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "363f9b23bd1b2139ba63d891e09e4d85e72ce0309fbda36ddcc9c315d0ef913c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb5f195be48a65151242a438ba3c489f8087dd7fe24fbfbb4c465f467a630a48"
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