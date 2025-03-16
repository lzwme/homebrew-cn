class Pumba < Formula
  desc "Chaos testing tool for Docker"
  homepage "https:github.comalexei-ledpumba"
  url "https:github.comalexei-ledpumbaarchiverefstags0.11.0.tar.gz"
  sha256 "3ed3cad724d9367e5acc55206a7304cd3eb3a6a28afd5ed00871e3a6266435d2"
  license "Apache-2.0"
  head "https:github.comalexei-ledpumba.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd30e2a7943986344f501cd9d95df10a688422516a7b2ef4f32af85de5563a06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd30e2a7943986344f501cd9d95df10a688422516a7b2ef4f32af85de5563a06"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bd30e2a7943986344f501cd9d95df10a688422516a7b2ef4f32af85de5563a06"
    sha256 cellar: :any_skip_relocation, sonoma:        "7cdbafb2e72fd78bc08d3a1d6e02e719ee6b7f6139be3d5f1fc1e1770688fe38"
    sha256 cellar: :any_skip_relocation, ventura:       "7cdbafb2e72fd78bc08d3a1d6e02e719ee6b7f6139be3d5f1fc1e1770688fe38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "477e8f8511df86beb38f862d30cf4d08e08225dbe39d9e4623ae61ff85b945a2"
  end

  depends_on "go" => :build

  def install
    goldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.branch=master
      -X main.buildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: goldflags), ".cmd"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}pumba --version")
    # CI runs in a Docker container, so the test does not run as expected.
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    output = pipe_output("#{bin}pumba rm test-container 2>&1")
    assert_match "Is the docker daemon running?", output
  end
end