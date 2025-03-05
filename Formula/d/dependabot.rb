class Dependabot < Formula
  desc "Tool for testing and debugging Dependabot update jobs"
  homepage "https:github.comdependabotcli"
  url "https:github.comdependabotcliarchiverefstagsv1.61.0.tar.gz"
  sha256 "fed39befb59094a72f05029754a78549a72d67b8aa0468b2c0b3f92371dbe600"
  license "MIT"
  head "https:github.comdependabotcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "632210a29dcc401b39663b485b77a2f63f87261204eead536cb940dea0a4a0ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "632210a29dcc401b39663b485b77a2f63f87261204eead536cb940dea0a4a0ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "632210a29dcc401b39663b485b77a2f63f87261204eead536cb940dea0a4a0ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "086ed25be5bd87a2a70d555953ee269d9c81cc794e3587eb71cf11ef4c6cfec8"
    sha256 cellar: :any_skip_relocation, ventura:       "086ed25be5bd87a2a70d555953ee269d9c81cc794e3587eb71cf11ef4c6cfec8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ed556945c6bfe0f36706efc8b9641434a04ba89d61313d7196e4be3fb46ce08"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comdependabotclicmddependabotinternalcmd.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmddependabot"

    generate_completions_from_executable(bin"dependabot", "completion")
  end

  test do
    ENV["DOCKER_HOST"] = "unix:#{testpath}invalid.sock"
    assert_match("dependabot version #{version}", shell_output("#{bin}dependabot --version"))
    output = shell_output("#{bin}dependabot update bundler Homebrewhomebrew 2>&1", 1)
    assert_match("Cannot connect to the Docker daemon", output)
  end
end