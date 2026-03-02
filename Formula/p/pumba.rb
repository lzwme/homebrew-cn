class Pumba < Formula
  desc "Chaos testing tool for Docker"
  homepage "https://github.com/alexei-led/pumba"
  url "https://ghfast.top/https://github.com/alexei-led/pumba/archive/refs/tags/1.0.4.tar.gz"
  sha256 "51c3d688dd41ea03d273882e8291e11e619a38c937f8f0d52a6527ccfe9438a8"
  license "Apache-2.0"
  head "https://github.com/alexei-led/pumba.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b6a195bd65253cd0ccb7764352fc1a3764989640a55ee87149998f0631ee35e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b6a195bd65253cd0ccb7764352fc1a3764989640a55ee87149998f0631ee35e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b6a195bd65253cd0ccb7764352fc1a3764989640a55ee87149998f0631ee35e"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea8b70e3f1ae5d6d11dd9e98524cf8a73ab4e47683761336d61ad7063c264cfb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf6b8faee8ab92508b9ff216c439b8c347b22391ae25ed259c09686d994fad74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "704d9901589381af4244edb201dc60f2f9d89035630f7e98ed8672e274d0ed5f"
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