class Temporal < Formula
  desc "Command-line interface for running and interacting with Temporal Server and UI"
  homepage "https:temporal.io"
  url "https:github.comtemporaliocliarchiverefstagsv0.13.1.tar.gz"
  sha256 "9d8812c96d3404490659fec3915dcd23c4142b421ef4cb7e9622bd9a459e1f74"
  license "MIT"
  head "https:github.comtemporaliocli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "46884e4f0989ed43e44fdf572c80a5de54c313abc35e48765c0331810884fc28"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b5ff32eb94520faf2964096de04935443d9ac5a6ff8de024b76cbfb9e112067"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07565d7e15928b54788fce3d0e210352d3fa13fb9f3fe92a73c81fb5b981310c"
    sha256 cellar: :any_skip_relocation, sonoma:         "ef67437ea15e85f3ca1f0dd62242c0d794d974a99f9d08220a48f84b94ede037"
    sha256 cellar: :any_skip_relocation, ventura:        "5539f822996073b1cc85b9c91c8dc7440bd4cc76fb1f9865744e04efa351c6aa"
    sha256 cellar: :any_skip_relocation, monterey:       "945ce2a1335a90080f3a56a1c121b5a9bb7eac4da54ee4c935df64349ec62c76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84f1500f89b71c872d6136796d9c34c9bec91f178f6f1e0108d8ab9c8dd778a3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comtemporalioclitemporalcli.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdtemporal"
    generate_completions_from_executable bin"temporal", "completion"
  end

  test do
    run_output = shell_output("#{bin}temporal --version")
    assert_match "temporal version #{version}", run_output

    run_output = shell_output("#{bin}temporal workflow list --address 192.0.2.0:1234 2>&1", 1)
    assert_match "failed reaching server", run_output
  end
end