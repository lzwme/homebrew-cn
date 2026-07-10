class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.32.1.tar.gz"
  sha256 "a9c1d627d285a410698a896277aea867439106374e88fdb6a14667c75654aa7d"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "429fc61b8501e2be26ad1d70b3dc23089082f9425506f7100c8ec2d663c0eacb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e328516bd1b53543963e93638af9ebc44541d2a9f6b6dbd02c409422142acc6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ad4297728c47ee9f10acbe3c44360bf2ab3ddeb07cda4b46cd8919cbbb9fa69"
    sha256 cellar: :any_skip_relocation, sonoma:        "786113e3929abe0233f1e5a37768fe93840def21e5f5e43a6332e937399963bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e67e7286af9be7d1b0c14cebacace28631160ee53c7bb1c63cf805304370fbf"
    sha256 cellar: :any,                 x86_64_linux:  "d0b0156a285bb35d741765bddc05ff7e728a5963e54583c49d3ccda603b19924"
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