class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://ghproxy.com/https://github.com/kosli-dev/cli/archive/refs/tags/v2.6.15.tar.gz"
  sha256 "7e6a31f40b550f70e37382af1f3e6f237db55bbd10ee497c845da01682cfa9dc"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "17936ae512e638b1b286a786dae5b1cd3ae9d81567b4a112423d86eaf36268b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d95620308c8ca2d1f39ad288a05af1cc9fe5222f8f135fc40b04eb50802841b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28942378e9ec56a2a635a95f1389146d2266276ff03fac45ea13774756a77047"
    sha256 cellar: :any_skip_relocation, sonoma:         "f5853ffdc1f548df3e63c55069342723491603db3129ff67e0446fe385b1d303"
    sha256 cellar: :any_skip_relocation, ventura:        "1b630dbda46ba3bd0fbe49a93a7d4718306b48e3a27353d4b5663d5c5f156c08"
    sha256 cellar: :any_skip_relocation, monterey:       "29e792e39b4d1d2b3ee1f92baee0d09bac64c1a4ed95a9fb0f61f3b8c36cad90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56aa4fc0de7ad63ff825dcf39df95ebb95b45c46bf57f87123f3a6a2ac801017"
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