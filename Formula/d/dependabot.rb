class Dependabot < Formula
  desc "Tool for testing and debugging Dependabot update jobs"
  homepage "https:github.comdependabotcli"
  url "https:github.comdependabotcliarchiverefstagsv1.65.0.tar.gz"
  sha256 "5dcca250abe53b23e914bb91b1d0ab50b4340eaa935064c01ff83b21d213748b"
  license "MIT"
  head "https:github.comdependabotcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c63ed94d1e0532251cc3f572e783663a73fe57e1c88b94a63af16a6175241ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c63ed94d1e0532251cc3f572e783663a73fe57e1c88b94a63af16a6175241ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2c63ed94d1e0532251cc3f572e783663a73fe57e1c88b94a63af16a6175241ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "6423663e68164e1cc4b1b6c9ada0480f5087e7d9f68f54d39012271fdeb338af"
    sha256 cellar: :any_skip_relocation, ventura:       "6423663e68164e1cc4b1b6c9ada0480f5087e7d9f68f54d39012271fdeb338af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1976076a4d9fc94259ff3b54d276ae125b1316b19f54780ddbef0339e2f97c95"
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