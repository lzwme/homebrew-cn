class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https:www.git-town.com"
  url "https:github.comgit-towngit-townarchiverefstagsv12.0.0.tar.gz"
  sha256 "6a7fe5b3911396be7bb485bc37d745986c7d3b95331f1e03dfd0bf277608cb14"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "90c43e27cdc79f4c7b946c27bc095dcb9ecc9a6c006b279d1dda0e147ac50ec5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2071adeb5f11699f64bdee875fe6d7b193a4a15d8b633b8cdca148683a0d8612"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1cb179ba5d2558c799a004546095bfbd3a0f2ea1fdc5bc3b1837f9f9bbaa9ebc"
    sha256 cellar: :any_skip_relocation, sonoma:         "d36de3c7e85c6703a39e0baf9bcf347e0c1b33b8ed91953603d8ad19565d81c7"
    sha256 cellar: :any_skip_relocation, ventura:        "b8c42e078fa8549ec6d91552487acc7c7b247047813420b43a806d9dccf519b0"
    sha256 cellar: :any_skip_relocation, monterey:       "40547e52e89ded6f67fba6c914929594ad099c14e17902afdaff9f8a1625886a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6cbb238e4689e007ae51fc949ddf85b82ce3d2c6e75c9c60256acc469e082de"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comgit-towngit-townv#{version.major}srccmd.version=v#{version}
      -X github.comgit-towngit-townv#{version.major}srccmd.buildDate=#{time.strftime("%Y%m%d")}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

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