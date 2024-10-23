class Dependabot < Formula
  desc "Tool for testing and debugging Dependabot update jobs"
  homepage "https:github.comdependabotcli"
  url "https:github.comdependabotcliarchiverefstagsv1.56.0.tar.gz"
  sha256 "be6793ae0c099fc3fafef37b6b2ee9c69f8ecce6a5f5f8f4bda31780a6560374"
  license "MIT"
  head "https:github.comdependabotcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a42a46771394f1e51b875a7cc4296e627c4744c9e8b308e487bb46925d6b9391"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a42a46771394f1e51b875a7cc4296e627c4744c9e8b308e487bb46925d6b9391"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a42a46771394f1e51b875a7cc4296e627c4744c9e8b308e487bb46925d6b9391"
    sha256 cellar: :any_skip_relocation, sonoma:        "6341d63108fe9546637598a7b4f646e9db0e2fff2a464659f381debf00ef859b"
    sha256 cellar: :any_skip_relocation, ventura:       "6341d63108fe9546637598a7b4f646e9db0e2fff2a464659f381debf00ef859b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee8b7f1a524cf0eb787084e97e611bd2f840bf98cc8185e92d8c19b1210283f5"
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