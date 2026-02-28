class Pumba < Formula
  desc "Chaos testing tool for Docker"
  homepage "https://github.com/alexei-led/pumba"
  url "https://ghfast.top/https://github.com/alexei-led/pumba/archive/refs/tags/1.0.3.tar.gz"
  sha256 "47cb64cfcb9198157bc6879a40fde2089ab968f19ce7fdeb98621aa68e86793a"
  license "Apache-2.0"
  head "https://github.com/alexei-led/pumba.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4148f0a2768eeaf1b623a03d7f405a00a0426a56d38d377db75020ed3c90bc34"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4148f0a2768eeaf1b623a03d7f405a00a0426a56d38d377db75020ed3c90bc34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4148f0a2768eeaf1b623a03d7f405a00a0426a56d38d377db75020ed3c90bc34"
    sha256 cellar: :any_skip_relocation, sonoma:        "6557912f0ae32e49e0c13f94267a1b588c3141cdee652c62d7e2e0679222f89e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c09b05bf8af901885831e95c1c53028522dd91e316eec933333a5b359c2022fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d92af76d982b313af715d7dc542ab4785fc2f764afed4ba538efbf36f142902d"
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