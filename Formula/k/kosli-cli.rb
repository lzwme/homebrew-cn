class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https:docs.kosli.comclient_reference"
  url "https:github.comkosli-devcliarchiverefstagsv2.7.3.tar.gz"
  sha256 "1f9f4ce76e111024dade67a37ab9038a4a0985ce4901c97a9a8fcf3a8acf5759"
  license "MIT"
  head "https:github.comkosli-devcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2a252ce1f9526d0a0a734dcbf4306cb8eb0760fb63a14450dc114bcef1f54cc0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5706c26f7176bf49bb2d53fdcf131c78a65266afd1c6130ea068abe3abe07a6b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d75b000259b035908b2699b41b6737f3d7db02e4be4d8c480726bde3285750be"
    sha256 cellar: :any_skip_relocation, sonoma:         "d62c5cef368b3050d91b1d6427224bfd3c5b64afaa497080140ae684027fa3ea"
    sha256 cellar: :any_skip_relocation, ventura:        "c38fe1fec89f80e96af1c8ee703d5351a56c59fd4c4b59636417d2438fbf60c4"
    sha256 cellar: :any_skip_relocation, monterey:       "da017e2bdcf536668e23fdad417260dd7eca37a6c39f25b249cc383d4219d88e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "710d6327c11f8af7480dfa552de15453d53077866a5ce0016e3590a9a2d0fc2c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comkosli-devcliinternalversion.version=#{version}
      -X github.comkosli-devcliinternalversion.gitCommit=#{tap.user}
      -X github.comkosli-devcliinternalversion.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin"kosli", ldflags: ldflags), ".cmdkosli"

    generate_completions_from_executable(bin"kosli", "completion", base_name: "kosli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}kosli version")

    assert_match "OK", shell_output("#{bin}kosli status")
  end
end