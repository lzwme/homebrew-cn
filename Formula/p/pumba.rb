class Pumba < Formula
  desc "Chaos testing tool for Docker"
  homepage "https://github.com/alexei-led/pumba"
  url "https://ghfast.top/https://github.com/alexei-led/pumba/archive/refs/tags/1.1.0.tar.gz"
  sha256 "c9da0446666a9869846fc06069410028b35fb8f54c5bb7b75162c1acd8385a13"
  license "Apache-2.0"
  head "https://github.com/alexei-led/pumba.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3e5e7d2b338220860222c35c8bde22e7dd7ba901774fbf73ccc4e3af0fa8d9d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3e5e7d2b338220860222c35c8bde22e7dd7ba901774fbf73ccc4e3af0fa8d9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3e5e7d2b338220860222c35c8bde22e7dd7ba901774fbf73ccc4e3af0fa8d9d"
    sha256 cellar: :any_skip_relocation, sonoma:        "8bc996b2386e370e99c96813cab9a6d3c4b682a802723004d9bb87acc54def3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eeec637e409034e424386509ff7a98701d94cccd4457a5e100b097bd070a6cc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d1cbe8b9da0b67c72c6bc07678ef55072635b7002ca7a63ab61df39727f7906"
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