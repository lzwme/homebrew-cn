class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https:www.git-town.com"
  url "https:github.comgit-towngit-townarchiverefstagsv16.1.1.tar.gz"
  sha256 "0ced1fbd47904dce0addc584f572f43ba965c25c9b38a5e4f7ebd481852e67d5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d7d20510c544bf8c91ca142d7ef39841094e100787cddbddf01862b3430c417e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d7d20510c544bf8c91ca142d7ef39841094e100787cddbddf01862b3430c417e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d7d20510c544bf8c91ca142d7ef39841094e100787cddbddf01862b3430c417e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7d20510c544bf8c91ca142d7ef39841094e100787cddbddf01862b3430c417e"
    sha256 cellar: :any_skip_relocation, sonoma:         "71bfa249709a1c8e64b36d0be8f3523acd0dbd355c83c42d61c435002e1617af"
    sha256 cellar: :any_skip_relocation, ventura:        "71bfa249709a1c8e64b36d0be8f3523acd0dbd355c83c42d61c435002e1617af"
    sha256 cellar: :any_skip_relocation, monterey:       "71bfa249709a1c8e64b36d0be8f3523acd0dbd355c83c42d61c435002e1617af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d306203cf9a367a8e6f58fbabf8b8609b38297d7b39de31e6c3e7c269982eae"
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