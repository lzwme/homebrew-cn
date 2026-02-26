class Pumba < Formula
  desc "Chaos testing tool for Docker"
  homepage "https://github.com/alexei-led/pumba"
  url "https://ghfast.top/https://github.com/alexei-led/pumba/archive/refs/tags/1.0.1.tar.gz"
  sha256 "e1bf9c03b05e2c6d1d599028cd93d0887299a629ad76793426d4ba6971e48b0b"
  license "Apache-2.0"
  head "https://github.com/alexei-led/pumba.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "643558d2de5a92aabd416d2b485e2888214c7a8052381a272e4fdc9701ea9d9e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "643558d2de5a92aabd416d2b485e2888214c7a8052381a272e4fdc9701ea9d9e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "643558d2de5a92aabd416d2b485e2888214c7a8052381a272e4fdc9701ea9d9e"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c2e178cd5a1e679955d498161e96fbdf3b8a8be6db3690e18b2be0dd66e69d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1992976b8fad3ffe24044ef0bf707a1f399759b4b4c049c73f36a864d64779f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "361664ca08eeb0b2eeb1d576c7ef0e38056045e52069ca492052994e6e04fa45"
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