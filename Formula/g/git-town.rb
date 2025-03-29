class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https:www.git-town.com"
  url "https:github.comgit-towngit-townarchiverefstagsv18.2.0.tar.gz"
  sha256 "b03c9e8640d2f89c7dce0c7c5fa87aeddb932ddd3c15d721bc74a4339a347300"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f949fc408eabc1af4145bd32782a80e754ba96b440eaccc8c5c39c7c7e04c1db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f949fc408eabc1af4145bd32782a80e754ba96b440eaccc8c5c39c7c7e04c1db"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f949fc408eabc1af4145bd32782a80e754ba96b440eaccc8c5c39c7c7e04c1db"
    sha256 cellar: :any_skip_relocation, sonoma:        "70d1c21525f0f9a6c523cd9b6730b62ff6f39b01e8e1325978e75aae5c169407"
    sha256 cellar: :any_skip_relocation, ventura:       "70d1c21525f0f9a6c523cd9b6730b62ff6f39b01e8e1325978e75aae5c169407"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e56aa52e4cf3863176f98dfb7d28c812b4ca4714d245e6b53ef2bc67562d0f0"
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