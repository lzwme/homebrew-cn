class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://ghproxy.com/https://github.com/vektra/mockery/archive/refs/tags/v2.32.2.tar.gz"
  sha256 "be16677b79bbb939298e9f516d022f65d863e9d0d4e65fcc109855e85a116ec6"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "de693e57264a88b3e1816bc89e9831ab4050d64c8bf130d7a48a5660b177bc53"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55a06ad27ac9d921cf52f053c9d458ec5a56e0bf818d3c2e9201076b0132f95f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d1921a7ba7ba1847d902301b3256436c3b93faa0c264c55f4108923109a93a29"
    sha256 cellar: :any_skip_relocation, ventura:        "52dd4da0ad3292a50bbf3d04672fc917b2f18078869727a7dadb3815e401f894"
    sha256 cellar: :any_skip_relocation, monterey:       "d6a9ab6f354a3525308a327a3330ce59d92afa001e959900bbd47866171b783e"
    sha256 cellar: :any_skip_relocation, big_sur:        "348e7bc05a6ab5d35e6ec9ad7f46384eed771230d7c7d4c5e16fb9605fabf5ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4ba682773b174e681216ad3677b0fead46b4acd5e31d904133397545e141865"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/vektra/mockery/v2/pkg/logging.SemVer=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"mockery", "completion")
  end

  test do
    output = shell_output("#{bin}/mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=v#{version}", output

    output = shell_output("#{bin}/mockery --all --dry-run 2>&1")
    assert_match "INF Starting mockery dry-run=true version=v#{version}", output
  end
end