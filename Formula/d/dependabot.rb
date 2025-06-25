class Dependabot < Formula
  desc "Tool for testing and debugging Dependabot update jobs"
  homepage "https:github.comdependabotcli"
  url "https:github.comdependabotcliarchiverefstagsv1.67.1.tar.gz"
  sha256 "d5ea07080038dcd569c8bf0992933398230b3fbf545d440a627c6d3fdc697b4d"
  license "MIT"
  head "https:github.comdependabotcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "903c28f2991765922a0c0d33002565b499e206ab5dfa0b7b75302d19bf5cb2bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "903c28f2991765922a0c0d33002565b499e206ab5dfa0b7b75302d19bf5cb2bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "903c28f2991765922a0c0d33002565b499e206ab5dfa0b7b75302d19bf5cb2bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "808154d0cf97f032c146f342fd3734753b8b90a9fd4dbdafcbf41690f427250e"
    sha256 cellar: :any_skip_relocation, ventura:       "808154d0cf97f032c146f342fd3734753b8b90a9fd4dbdafcbf41690f427250e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b318329155ade65fd3372ed07fe118c178d7e05fde64b63074fb85ae6bd0697e"
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