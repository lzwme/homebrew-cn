class Dockerize < Formula
  desc "Utility to simplify running applications in docker containers"
  homepage "https:github.comjwilderdockerize"
  url "https:github.comjwilderdockerizearchiverefstagsv0.9.1.tar.gz"
  sha256 "315f7d5c9eb7456656cd80f54176ff6fe7345b243d3ecdb353db405384eae9c8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e506c61dcd689f0ebaeccc88e593169bb60b22fb66543f0381506a418da33087"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e506c61dcd689f0ebaeccc88e593169bb60b22fb66543f0381506a418da33087"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e506c61dcd689f0ebaeccc88e593169bb60b22fb66543f0381506a418da33087"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd374ec4ae14ee340582aa86058a0408070ef919110d37a73279559cf5b18e64"
    sha256 cellar: :any_skip_relocation, ventura:       "dd374ec4ae14ee340582aa86058a0408070ef919110d37a73279559cf5b18e64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "558caf666a5d35c50ddaba4784a441a2b5331a3393f2530a05f2764a276baaae"
  end

  depends_on "go" => :build
  conflicts_with "powerman-dockerize", because: "powerman-dockerize and dockerize install conflicting executables"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.buildVersion=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}dockerize --version")
    system bin"dockerize", "-wait", "https:www.google.com", "-wait-retry-interval=1s", "-timeout", "5s"
  end
end