class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.30.0.tar.gz"
  sha256 "f17b92701766e2d6b466ec1dc11221a7114994702a41b36214c1da5df7842793"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6a70aa48bf61a28ce33f01619cf01d8ca4d59ef9e7b1cc4813bd5fc4fdddf4df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4793f0c62d865f8114af2ba2891e726e5896206641bb41b0619d2aae58e4da2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23d8135f7e04399e8c5a276638379a4ea5ec139b4bacf5792153e29cb7b1c6d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a622d946c540f8a6507d15c54c938fe3608829f566a6385d0444d8922dfe812"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4281ce0bae0998c580c410da0a5af4e8c25c8ad80b868256ddc1cf53f60fc7c8"
    sha256 cellar: :any,                 x86_64_linux:  "fa187e5e8d4360d1f1e42b9c9a24524835e6f02e8f5a6bf8b0d1a1048ec30122"
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