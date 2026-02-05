class Dockerize < Formula
  desc "Utility to simplify running applications in docker containers"
  homepage "https://github.com/jwilder/dockerize"
  url "https://ghfast.top/https://github.com/jwilder/dockerize/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "15faeef280e2e6f819c0c26e5248e6673e366b0964d5d85d580eb8a57c9e19b3"
  license "MIT"
  head "https://github.com/jwilder/dockerize.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1df859550462120b1aa9ef424192cbabc42e6080e6776ecfa524ba5f14e93744"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1df859550462120b1aa9ef424192cbabc42e6080e6776ecfa524ba5f14e93744"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1df859550462120b1aa9ef424192cbabc42e6080e6776ecfa524ba5f14e93744"
    sha256 cellar: :any_skip_relocation, sonoma:        "79fad04774056b5df825858fea8fbc3b8763afdd6defae8163c8769022eeaabf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "808458a72ba60b338cd96467466aa8ee0336a4830ce2bf755f985ca55351a6f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5178419448af4ada87f97a972eb696950f1b7555588d5bb33e2c7253baf9244"
  end

  depends_on "go" => :build
  conflicts_with "powerman-dockerize", because: "powerman-dockerize and dockerize install conflicting executables"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.buildVersion=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockerize --version")
    system bin/"dockerize", "-wait", "https://www.google.com/", "-wait-retry-interval=1s", "-timeout", "5s"
  end
end