class Pumba < Formula
  desc "Chaos testing tool for Docker"
  homepage "https://github.com/alexei-led/pumba"
  url "https://ghfast.top/https://github.com/alexei-led/pumba/archive/refs/tags/1.1.3.tar.gz"
  sha256 "137cdbd7988abd682bf9594febba454b41319d13f26b2bdb65b5226f0a33efd7"
  license "Apache-2.0"
  head "https://github.com/alexei-led/pumba.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "87e37c35ec8cf04e0116f6321ecc51b62d198cf1c38ef6e97bf225518f4cb2e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87e37c35ec8cf04e0116f6321ecc51b62d198cf1c38ef6e97bf225518f4cb2e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87e37c35ec8cf04e0116f6321ecc51b62d198cf1c38ef6e97bf225518f4cb2e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e1696d92b4ed8128219df45a8972763f02afcf4aaa4efc6a863db5c2e5ec8fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "551e2d8b462ecb569eaf8e07a7c1af117101412e9578b447e077e2e01a35e117"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae660de71ebab2e3dd6435a2cf35f5e31e64fd6d295b8a80068ca60071036aeb"
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