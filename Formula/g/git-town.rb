class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https:www.git-town.com"
  url "https:github.comgit-towngit-townarchiverefstagsv16.6.1.tar.gz"
  sha256 "d792444e5779542ef00a414f39294d088760579464a21f85791f3388454df391"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "587e32ad346f8a5931807b82a82b2218252adab9b88270239da5420d627cbc91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "587e32ad346f8a5931807b82a82b2218252adab9b88270239da5420d627cbc91"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "587e32ad346f8a5931807b82a82b2218252adab9b88270239da5420d627cbc91"
    sha256 cellar: :any_skip_relocation, sonoma:        "cab689a033d4d661f2db9051521bde200639fde0eb97ab77ee5e71021435a2c6"
    sha256 cellar: :any_skip_relocation, ventura:       "cab689a033d4d661f2db9051521bde200639fde0eb97ab77ee5e71021435a2c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66a129294ef05fc0f7f96a73963cc78fa1f4d990d4f97ba781d9b3b51fc294ca"
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