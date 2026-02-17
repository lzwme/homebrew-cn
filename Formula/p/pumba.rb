class Pumba < Formula
  desc "Chaos testing tool for Docker"
  homepage "https://github.com/alexei-led/pumba"
  url "https://ghfast.top/https://github.com/alexei-led/pumba/archive/refs/tags/0.11.10.tar.gz"
  sha256 "c161b4341dba355b2cfcb16ec87c02e042bacc443289bcf8b90033213b5f23bd"
  license "Apache-2.0"
  head "https://github.com/alexei-led/pumba.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ec00c850ae8dc73ad1a27ae70ed62afbd0b82727411a29f7653cc3276648206"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ec00c850ae8dc73ad1a27ae70ed62afbd0b82727411a29f7653cc3276648206"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ec00c850ae8dc73ad1a27ae70ed62afbd0b82727411a29f7653cc3276648206"
    sha256 cellar: :any_skip_relocation, sonoma:        "d632b131ff5d28d3dd53126d1bb2c0e0d5bdd58e7cdbcd01dde5d0b3589cfddf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0f70d23682ddaddcd38977b3bb99625e8f5680bff47fb3668b8f303a29cd499"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29926aba64c0872f3058df482076b05cadd71fa29fc1ca4c2eebf557534f9c92"
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