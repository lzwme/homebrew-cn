class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://ghproxy.com/https://github.com/git-town/git-town/archive/refs/tags/v9.0.1.tar.gz"
  sha256 "0fb557d1423765077522b37e64daca4883a1ff1c267b321e3822871872a8fa45"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "309be11132a16517913790c7638355b6a9c0c32ba4572b19c26acd95e2ec4cc3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "309be11132a16517913790c7638355b6a9c0c32ba4572b19c26acd95e2ec4cc3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "309be11132a16517913790c7638355b6a9c0c32ba4572b19c26acd95e2ec4cc3"
    sha256 cellar: :any_skip_relocation, ventura:        "d2a6e110b9216bfb3cb3b6e02228e060b0076d9335fed505f1a8943f2e2db68d"
    sha256 cellar: :any_skip_relocation, monterey:       "d2a6e110b9216bfb3cb3b6e02228e060b0076d9335fed505f1a8943f2e2db68d"
    sha256 cellar: :any_skip_relocation, big_sur:        "d2a6e110b9216bfb3cb3b6e02228e060b0076d9335fed505f1a8943f2e2db68d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4edaffc6c5cd2cc6765fcc36327c18e99eab2b09c681a39d09ca9f41330ad657"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/git-town/git-town/v9/src/cmd.version=v#{version}
      -X github.com/git-town/git-town/v9/src/cmd.buildDate=#{time.strftime("%Y/%m/%d")}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    # Install shell completions
    generate_completions_from_executable(bin/"git-town", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-town version")

    system "git", "init"
    touch "testing.txt"
    system "git", "add", "testing.txt"
    system "git", "commit", "-m", "Testing!"

    system bin/"git-town", "config"
  end
end