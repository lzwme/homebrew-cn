class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https:www.git-town.com"
  url "https:github.comgit-towngit-townarchiverefstagsv16.4.0.tar.gz"
  sha256 "99a50ad8c3713c86304f3858facc1e7ed20ae7077e4c9d8b4a324b7c62b97c5d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32b5dc090184a7d39f83b261423619704f8faa0c4777cf0df5bc21e65262c3e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32b5dc090184a7d39f83b261423619704f8faa0c4777cf0df5bc21e65262c3e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "32b5dc090184a7d39f83b261423619704f8faa0c4777cf0df5bc21e65262c3e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "c97f0daef7efee269bc794bf5358542646f4d623698b8ead828417a3d4d8bd8b"
    sha256 cellar: :any_skip_relocation, ventura:       "c97f0daef7efee269bc794bf5358542646f4d623698b8ead828417a3d4d8bd8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e101caacdbf1fe4cfd2f53fca09a6839b4cd39b23d2fc7ce9ec77d59997fe59a"
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