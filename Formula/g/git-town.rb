class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://ghproxy.com/https://github.com/git-town/git-town/archive/refs/tags/v10.0.1.tar.gz"
  sha256 "c7f756dcbbe3d8a293c04d61d12c55864c08198b855cf2f2095f5ac03593c1da"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "06477fe58f6c4df15caaf33b373f07b1b2e19c3a61d48c349b7bf163501592f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d040ec9a33eb1207d80578c26ab34a90b14385e7f5980bbdfb986431e07b8dc6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "21589a39ad3e4cd07e2ea5f3b39940026a58100533fc6e4ea60f7bfef88a7913"
    sha256 cellar: :any_skip_relocation, sonoma:         "41c50cfc1a81cfa86112009ce4e44dcd3a3a5caa079f94957b434faf4e7326e7"
    sha256 cellar: :any_skip_relocation, ventura:        "a1f288a305e0a6eb66f525715009497e33de0290ec4919594b5bebb62c0917b5"
    sha256 cellar: :any_skip_relocation, monterey:       "dc76eb45d881afd17b9544c0d015530b2d6164dec80f25e6139247cbb167482a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9ce21f679b69ae0f76ba4052471dba5eaebc36afbd8deef7b054c146550a7bf"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/git-town/git-town/v10/src/cmd.version=v#{version}
      -X github.com/git-town/git-town/v10/src/cmd.buildDate=#{time.strftime("%Y/%m/%d")}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    # Install shell completions
    generate_completions_from_executable(bin/"git-town", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-town -V")

    system "git", "init"
    touch "testing.txt"
    system "git", "add", "testing.txt"
    system "git", "commit", "-m", "Testing!"

    system bin/"git-town", "config"
  end
end