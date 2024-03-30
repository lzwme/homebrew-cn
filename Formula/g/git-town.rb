class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https:www.git-town.com"
  url "https:github.comgit-towngit-townarchiverefstagsv13.0.2.tar.gz"
  sha256 "fbaf96310cd08d08b00f2499da762f0b2e7c4af29dc458fe3cb36d80abac9670"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "206ed1b46a9ec80e098a93cf0cd57b056430861aacf070d8ac9220697ff13c34"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e66656e231954e93198905b007e9a830bec9802b993ce2051d4caf7820818aa6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81d7ac32c15e2d6d72c9e80d454f8f07e46d1fcb81c994774851390c6672dee5"
    sha256 cellar: :any_skip_relocation, sonoma:         "affefaba5a899e4f8cc32a1410f14d77796d1a2fd8bed874437d0a73c2c90a47"
    sha256 cellar: :any_skip_relocation, ventura:        "66369b18e8bd1458ced3ce2c4729148f301cbc57452f1f6b702b63d356f98402"
    sha256 cellar: :any_skip_relocation, monterey:       "4a85c5bb581d015ca4cee06aafee0e07f0ff2284d6902d6dd8e85e8dca8a32ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4794553a75177dd5e97fc5488357ed2e11a9692748dc81527a679e63ecbb7c9a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comgit-towngit-townv#{version.major}srccmd.version=v#{version}
      -X github.comgit-towngit-townv#{version.major}srccmd.buildDate=#{time.strftime("%Y%m%d")}
    ]
    system "go", "build", *std_go_args(ldflags:)

    # Install shell completions
    generate_completions_from_executable(bin"git-town", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}git-town -V")

    system "git", "init"
    touch "testing.txt"
    system "git", "add", "testing.txt"
    system "git", "commit", "-m", "Testing!"

    system bin"git-town", "config"
  end
end