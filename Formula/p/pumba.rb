class Pumba < Formula
  desc "Chaos testing tool for Docker"
  homepage "https://github.com/alexei-led/pumba"
  url "https://ghfast.top/https://github.com/alexei-led/pumba/archive/refs/tags/1.1.4.tar.gz"
  sha256 "d8506369411ed64eba882eb8bef68d667e5a5788ac1718d1b9571e8e5425a01d"
  license "Apache-2.0"
  head "https://github.com/alexei-led/pumba.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b86f2f123cb5483d0bc14363075cc6507232025c7d3c9e4259788e810467d8ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b86f2f123cb5483d0bc14363075cc6507232025c7d3c9e4259788e810467d8ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b86f2f123cb5483d0bc14363075cc6507232025c7d3c9e4259788e810467d8ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f2dee12c944d9e61b78bdf9ef9bfc6be9c5e20b049b5f7056ba2898f7049fbe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "814a421832b4b93b9205d1e0c6fa47365642955b43eb7b219b85108ce496093c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3891d4b5c715fb18a945cbb7f65f254735e802fef89aa0ef0756bb2b75485811"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.branch=master
      -X main.buildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pumba --version")

    # Linux CI container on GitHub actions exposes Docker socket but lacks permissions to read
    expected = if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      "/var/run/docker.sock: connect: permission denied"
    else
      "Is the docker daemon running?"
    end

    assert_match expected, shell_output("#{bin}/pumba rm test-container 2>&1", 1)
  end
end