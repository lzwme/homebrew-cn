class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https:www.git-town.com"
  url "https:github.comgit-towngit-townarchiverefstagsv14.3.0.tar.gz"
  sha256 "1cf12f2265a8f8870318698918d086074b8a142b23e0e9c1e7245afc21547577"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "84296bcadfb8c8c7b9b801013b8d96e4510eee102ba64e060ac6644b59d14520"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e6fab8537f5ef46488f21b28db9c020b8df9a1652c4215d981d93f517ed6eebf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2709a071a4cfdbef0196e49cbec0aa16659c316c829dc2460e52392b13caec77"
    sha256 cellar: :any_skip_relocation, sonoma:         "ec68813992d17c65dc3baca136f0fe99c779ae30b28cc8b70f3b42aec551a6c4"
    sha256 cellar: :any_skip_relocation, ventura:        "50ef7128cdf64c5689784fad68fd6687aaaee668e32f5125fd5c1d3233d1017b"
    sha256 cellar: :any_skip_relocation, monterey:       "c38f6c70bfb47d5e5714b549e30ef345c7ad59b489c8967096696e80cd208c32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a8ad813eca15fd234d4fead8dc1b879022d62a77e90fef13f36aba362a0eb97"
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