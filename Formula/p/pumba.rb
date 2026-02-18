class Pumba < Formula
  desc "Chaos testing tool for Docker"
  homepage "https://github.com/alexei-led/pumba"
  url "https://ghfast.top/https://github.com/alexei-led/pumba/archive/refs/tags/0.12.2.tar.gz"
  sha256 "39cf30af98c3cc62a3baf5ceced2f9c8a88004b452d7fb707707972170e9c624"
  license "Apache-2.0"
  head "https://github.com/alexei-led/pumba.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a115eeab3e511113488707fdc179198f69ce8b4594fba80551428ec17aaa793"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a115eeab3e511113488707fdc179198f69ce8b4594fba80551428ec17aaa793"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a115eeab3e511113488707fdc179198f69ce8b4594fba80551428ec17aaa793"
    sha256 cellar: :any_skip_relocation, sonoma:        "02e0ceb817e411db6e89445a04afc365ad9199d97b63f0ffd7c182bd51b23279"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67bfb439dc81d921481e80767d622f212924d72dfa6a40dd0074863cb248c410"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99f0b22f7259cc314af699a38fb6270ca66578541a41d4a2ed784a40931c8a88"
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