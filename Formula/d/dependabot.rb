class Dependabot < Formula
  desc "Tool for testing and debugging Dependabot update jobs"
  homepage "https:github.comdependabotcli"
  url "https:github.comdependabotcliarchiverefstagsv1.64.0.tar.gz"
  sha256 "c6dc6564636b01ab90e24315e37213253d43d5f91fc960e2d66791d29641730c"
  license "MIT"
  head "https:github.comdependabotcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d470f7876372b442525a124b8d9ce8338ac87279f54158254922f1b3fb7fd565"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d470f7876372b442525a124b8d9ce8338ac87279f54158254922f1b3fb7fd565"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d470f7876372b442525a124b8d9ce8338ac87279f54158254922f1b3fb7fd565"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2d8666b05c47322491b85689ba5d287f2a29a900fdc2a45e0eda16fe26842a5"
    sha256 cellar: :any_skip_relocation, ventura:       "f2d8666b05c47322491b85689ba5d287f2a29a900fdc2a45e0eda16fe26842a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20b74ba6cb04275a3e0201be2bc38657b5121686943caab84afafba57466a574"
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