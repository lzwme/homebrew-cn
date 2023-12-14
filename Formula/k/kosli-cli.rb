class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://ghproxy.com/https://github.com/kosli-dev/cli/archive/refs/tags/v2.6.17.tar.gz"
  sha256 "ca944ea6dc75cb907efd3b057838dc713af8729b1c96a3a413e704ff7b0bf357"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9a396933dabfe494f4c7d2967e94fa54126d95b78e74dc9350c92e7bd814cdd0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9feb25205f63515ee39dc6642bcd420c6627265c2b4cb0a83fae04d0f0568dc5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c6d11d409b18366fb919030ff7a45ce747acb1f04cdb502d5c094ba2cdc261d"
    sha256 cellar: :any_skip_relocation, sonoma:         "5f6570b340b24fa0b0f6351e0e29fe54d5ac5fca08cd140c72cd1d8d082a17ec"
    sha256 cellar: :any_skip_relocation, ventura:        "6e49b7501a1f4bf3ae51825280778f8f29785071539896f981d906d5f2ed3b74"
    sha256 cellar: :any_skip_relocation, monterey:       "4b434b317fd49e89e113e6b942359135e6cf69ec0d771f8d2f9c3d6c7cbe1bf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37c9f85a5b92360cbcdd7c784bac535011d5954617d4cb4ad8d7fcb545331ef6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/kosli-dev/cli/internal/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin/"kosli", ldflags: ldflags), "./cmd/kosli"

    generate_completions_from_executable(bin/"kosli", "completion", base_name: "kosli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end