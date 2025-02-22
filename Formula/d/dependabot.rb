class Dependabot < Formula
  desc "Tool for testing and debugging Dependabot update jobs"
  homepage "https:github.comdependabotcli"
  url "https:github.comdependabotcliarchiverefstagsv1.60.0.tar.gz"
  sha256 "1e5fd1f5ce77d8cfca9978e9993ec14164e763cf92016101e1d67a409e05d638"
  license "MIT"
  head "https:github.comdependabotcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c23f515d21ff6a1b5ed1ab17de9edea783b66d5f5876d48be1639c7fa9af44d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c23f515d21ff6a1b5ed1ab17de9edea783b66d5f5876d48be1639c7fa9af44d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c23f515d21ff6a1b5ed1ab17de9edea783b66d5f5876d48be1639c7fa9af44d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "c166325d7079ec16d63149a349471e67efd656a25ca5ee329c376c69844a6703"
    sha256 cellar: :any_skip_relocation, ventura:       "c166325d7079ec16d63149a349471e67efd656a25ca5ee329c376c69844a6703"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5677130493c4ee7da51e6fb2ee7e3471e25681bccf935e55cd79ef92455ffa3"
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