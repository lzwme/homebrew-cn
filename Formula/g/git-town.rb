class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https:www.git-town.com"
  url "https:github.comgit-towngit-townarchiverefstagsv12.0.1.tar.gz"
  sha256 "52e5f380a89c45e6497eb9ed2760660f40d3680e24262cb84939a51dd95e4cce"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1619cc3501608b9fb84a1ff3ddd27579e47b447d69c12a844c34660f9dee1bc1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "31010ecd8fb51e933f00cc307453ee7bad4aec1a8bf5269c826c4240e45f9ab1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a82d01917acccbe88e92a61fbd5e4fd9a7cb7705ab52b35caee15b2ed8dcbdc4"
    sha256 cellar: :any_skip_relocation, sonoma:         "a52aa48efb6230c03d4d28e970ee478f12091f662902c68b93175190dee94968"
    sha256 cellar: :any_skip_relocation, ventura:        "96a78931f17a5f02a22ba4b013fc2f7f06da10a559152070b4abd177c714ebd5"
    sha256 cellar: :any_skip_relocation, monterey:       "b4ebe71ee35e2deee3ff21f20aa3397e0fe749e9d1e861b9a038bb31005d2db8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d8f413e68aa1642e3839e6d384e27936bc6c879f3551d7cf12236253c0f0bee"
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