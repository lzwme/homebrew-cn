class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https:www.git-town.com"
  url "https:github.comgit-towngit-townarchiverefstagsv14.2.1.tar.gz"
  sha256 "96038b08574ff79a09ae56ecf0470dd7f8a3bd676e64dfd7c06c1b3b98ceb897"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1fdbb834e947994693069e14d995cad358c8e33c2c485eb76374c4b009b68543"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "197a0224742db31c94ddf3c3001a758aa091f5762c79d10818c6279c8fd7486d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a15831bac8b3fb9b018d1b4cda40e3adc8262f5a07f9506a75fd1b7d4eca8889"
    sha256 cellar: :any_skip_relocation, sonoma:         "fd50515c64e694b6e5456addaaaa4efe27aade49a3d9de42e859cbaa61338fc0"
    sha256 cellar: :any_skip_relocation, ventura:        "e59e4964bd0de5bc9b742958abb72c9eb2b50341f9d6d4ecf93fe56efeae115b"
    sha256 cellar: :any_skip_relocation, monterey:       "7ec4317e96ef939fd24e821c6d28d440408c5015248e5a69b5912f507549a06f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "247c406909bfea5d967515ff2536cf17f790e54794e0fde5b7b8a0021e00dbfd"
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