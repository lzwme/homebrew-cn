class Dependabot < Formula
  desc "Tool for testing and debugging Dependabot update jobs"
  homepage "https:github.comdependabotcli"
  url "https:github.comdependabotcliarchiverefstagsv1.59.0.tar.gz"
  sha256 "1a9930ae99ab318f8b0b1684b4613e86fa650e18e97b8c607748d82ffe6a9b7c"
  license "MIT"
  head "https:github.comdependabotcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e02372156f7503b59e54f33d5e8fdbab3afd633b10404aea97ee7b9d30f9123f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e02372156f7503b59e54f33d5e8fdbab3afd633b10404aea97ee7b9d30f9123f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e02372156f7503b59e54f33d5e8fdbab3afd633b10404aea97ee7b9d30f9123f"
    sha256 cellar: :any_skip_relocation, sonoma:        "04670377d96c031cd2bf064c8ee3107aedf2179f4c4f95f3111199aa005881d2"
    sha256 cellar: :any_skip_relocation, ventura:       "04670377d96c031cd2bf064c8ee3107aedf2179f4c4f95f3111199aa005881d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9144813d7fb89f6d319779a919c88f992282fa640ce9476b13740b8ad600fead"
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