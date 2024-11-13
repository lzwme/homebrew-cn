class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https:www.git-town.com"
  url "https:github.comgit-towngit-townarchiverefstagsv16.6.0.tar.gz"
  sha256 "4eed540bd9cdd876095745e7065093aa6302d34e0cdfba4faabffef33b224f4e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae64d634335fcb79460b3f1b6a3b5b0e4ace448985dc7d73187dafe9376ba0d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae64d634335fcb79460b3f1b6a3b5b0e4ace448985dc7d73187dafe9376ba0d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ae64d634335fcb79460b3f1b6a3b5b0e4ace448985dc7d73187dafe9376ba0d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "d79a45c405b1f697fb447e5fd7dc5df81935310720803deee9cbe2649bb245f4"
    sha256 cellar: :any_skip_relocation, ventura:       "d79a45c405b1f697fb447e5fd7dc5df81935310720803deee9cbe2649bb245f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08d068c8eea7e00ea9258977fb58711182c5167a95f844c0444ac8f7bdc041ab"
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