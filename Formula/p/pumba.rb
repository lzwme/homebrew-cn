class Pumba < Formula
  desc "Chaos testing tool for Docker"
  homepage "https://github.com/alexei-led/pumba"
  url "https://ghfast.top/https://github.com/alexei-led/pumba/archive/refs/tags/1.0.5.tar.gz"
  sha256 "05b4e24437079ae5ca706f3f79c74206c2e22f10d75b5d1b6b61049b19d805f4"
  license "Apache-2.0"
  head "https://github.com/alexei-led/pumba.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fdb8d53cbf22c80d4ea52a17e7f237fbbfa375efb43d387e89a89ab7c2cb4369"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fdb8d53cbf22c80d4ea52a17e7f237fbbfa375efb43d387e89a89ab7c2cb4369"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fdb8d53cbf22c80d4ea52a17e7f237fbbfa375efb43d387e89a89ab7c2cb4369"
    sha256 cellar: :any_skip_relocation, sonoma:        "7590f7ba3d2bdbe9deeed7b76d4c6bdba24ae2924fe0d50b530a77d12b438a2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "392ccfab2a300de6bdc740996eaf09c871824637ff08a1250b0e8f8fe223c16f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f5d37aef21f333cffef0a56877b7b7421da7d72d438b3ee47cca0a4d349abc1"
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