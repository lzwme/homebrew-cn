class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https:www.git-town.com"
  url "https:github.comgit-towngit-townarchiverefstagsv16.2.1.tar.gz"
  sha256 "118f0ce45ffe515bded4510fb13e37d6421aad36a83ddefdf56e7539da6a52d5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ce403982dc90bb332f64ae82c660d77f581ec28a3f8dfa00748b1f9d787ef8ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce403982dc90bb332f64ae82c660d77f581ec28a3f8dfa00748b1f9d787ef8ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce403982dc90bb332f64ae82c660d77f581ec28a3f8dfa00748b1f9d787ef8ec"
    sha256 cellar: :any_skip_relocation, sonoma:         "14a384fc70d3df70f07dd003abdd937790f571e1fe6420a0da4200cc3ffc1a0e"
    sha256 cellar: :any_skip_relocation, ventura:        "14a384fc70d3df70f07dd003abdd937790f571e1fe6420a0da4200cc3ffc1a0e"
    sha256 cellar: :any_skip_relocation, monterey:       "14a384fc70d3df70f07dd003abdd937790f571e1fe6420a0da4200cc3ffc1a0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e9a03ff4ccb744ea3de5cd2b3cd64ff99b1f6f29a21cceec557e838b433d3aa"
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