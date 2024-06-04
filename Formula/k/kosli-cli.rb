class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https:docs.kosli.comclient_reference"
  url "https:github.comkosli-devcliarchiverefstagsv2.10.6.tar.gz"
  sha256 "cdfa492a5230fff69cb8c5871560e869d7a8c93ece82038a7f0e439763aa41f3"
  license "MIT"
  head "https:github.comkosli-devcli.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c79597305c4b6f1a193a574bcf23c27969759b3a934c811b4dbecf5df65cc638"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a866501c0d717f72be3f83d50e2df3a375964ac91b28214a5796b3137b0b57a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "838f951d85b0d558ecc4bc01bf24102b5f866cd717fd12659d8ed155cb289f5f"
    sha256 cellar: :any_skip_relocation, sonoma:         "fac17a4deb7fceaa391764ebebb83ef834c8ceaac7c40b99072491e36c8af635"
    sha256 cellar: :any_skip_relocation, ventura:        "44bab066c119558ea8e9bb8d345fc5aa49ffb6549af549457721bf08967720a4"
    sha256 cellar: :any_skip_relocation, monterey:       "8e0842003bdce6f2008cb53e9cfa61a9930c70cc505ad82d4e57ec7ebece2d17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0dd26536d7d525df58fd9b3dc07774fa563e5a0fd21e1eec10b758ae084e3408"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comkosli-devcliinternalversion.version=#{version}
      -X github.comkosli-devcliinternalversion.gitCommit=#{tap.user}
      -X github.comkosli-devcliinternalversion.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin"kosli", ldflags:), ".cmdkosli"

    generate_completions_from_executable(bin"kosli", "completion", base_name: "kosli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}kosli version")

    assert_match "OK", shell_output("#{bin}kosli status")
  end
end