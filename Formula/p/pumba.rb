class Pumba < Formula
  desc "Chaos testing tool for Docker"
  homepage "https:github.comalexei-ledpumba"
  url "https:github.comalexei-ledpumbaarchiverefstags0.11.3.tar.gz"
  sha256 "eff8edd57972754bf0401f600e57c7f21c61bcaa3bb8a41d33a48859a4306164"
  license "Apache-2.0"
  head "https:github.comalexei-ledpumba.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15cf3d601e95dc76edee70e46867617015f0585c1d615f4185e45c10e2d1263e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15cf3d601e95dc76edee70e46867617015f0585c1d615f4185e45c10e2d1263e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "15cf3d601e95dc76edee70e46867617015f0585c1d615f4185e45c10e2d1263e"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e2c502b740eb6c77c96a3abddf2eaacdb704f214e3a70c4011763d870648d46"
    sha256 cellar: :any_skip_relocation, ventura:       "4e2c502b740eb6c77c96a3abddf2eaacdb704f214e3a70c4011763d870648d46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "373bb9d0a6afe21c38024a8c7225e9f9b5836fdbd4063b9036fbbb6f5567d8d2"
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