class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https:www.git-town.com"
  url "https:github.comgit-towngit-townarchiverefstagsv16.0.0.tar.gz"
  sha256 "ad5fc7b88ca053dc9c515c7a57cd0fa7afca879fa90960d4a885f7037ca7bde1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3cd68c616501c748f44eae2053db649a1685e46490904c5f1d01abe0ca1b9396"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3cd68c616501c748f44eae2053db649a1685e46490904c5f1d01abe0ca1b9396"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3cd68c616501c748f44eae2053db649a1685e46490904c5f1d01abe0ca1b9396"
    sha256 cellar: :any_skip_relocation, sonoma:         "6bd4593e9347a4e69fb9a9374442d2154d872688352545b8712827921b50d3df"
    sha256 cellar: :any_skip_relocation, ventura:        "6bd4593e9347a4e69fb9a9374442d2154d872688352545b8712827921b50d3df"
    sha256 cellar: :any_skip_relocation, monterey:       "6bd4593e9347a4e69fb9a9374442d2154d872688352545b8712827921b50d3df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a19a5d140e0c2cba1e3b353e42ed7fa2f3e0d03cda0d03f54ee551f52840d103"
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