class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https:okteto.com"
  url "https:github.comoktetooktetoarchiverefstags2.27.3.tar.gz"
  sha256 "19db5c386fa4dfaaecd6cd1a7147e3379606556454124dda947ccc05ff40d625"
  license "Apache-2.0"
  head "https:github.comoktetookteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9ff28f21c7b599bd994d9a96e6d28a2de8f06ecfa2ae17b869eafb34e8ec694e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "562db112e859022c74fff97652055c51f6445eb1e4dadd229b313e3a5c29f0cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93c3a449c62f7ec7d25cd6d3da349e9f009efafc17cf7c3246801fcf4d2e0974"
    sha256 cellar: :any_skip_relocation, sonoma:         "f03937618f854c0252dbec8d51b10da5d2db901c50b3096d366c1054a9b4b8b9"
    sha256 cellar: :any_skip_relocation, ventura:        "79fe8fdd4708dbec903e0c4a0b846db07201445f031e01b4b9e7ffa1b1aa87a0"
    sha256 cellar: :any_skip_relocation, monterey:       "ee897a6be93420abb830da7caa7f1c120b9539d42d71c21a6ffba39a03ecbe6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa7253c4ce3e962bf39660ad96ff732313dd7de6cfea14f23849ef33b716df85"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comoktetooktetopkgconfig.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags:), "-tags", tags

    generate_completions_from_executable(bin"okteto", "completion")
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}okteto version")

    assert_match "Please run 'okteto context' to select one context",
      shell_output(bin"okteto init --context test 2>&1", 1)

    assert_match "Your context is not set",
      shell_output(bin"okteto context list 2>&1", 1)
  end
end