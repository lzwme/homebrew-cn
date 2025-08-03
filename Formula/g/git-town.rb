class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://ghfast.top/https://github.com/git-town/git-town/archive/refs/tags/v21.4.0.tar.gz"
  sha256 "48e13035628c9a847ed00820e7557ba1ce88488107df39bcd038d50c7e297b44"
  license "MIT"
  head "https://github.com/git-town/git-town.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "712ede9b08e857a07fdab0d7d50f67bec3eec80f367452f6d3b5fdb72eb238bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "712ede9b08e857a07fdab0d7d50f67bec3eec80f367452f6d3b5fdb72eb238bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "712ede9b08e857a07fdab0d7d50f67bec3eec80f367452f6d3b5fdb72eb238bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8c0857e95e6eca54a662bf5ddb8ea55184acde55f05a48298f788ad443acbb1"
    sha256 cellar: :any_skip_relocation, ventura:       "c8c0857e95e6eca54a662bf5ddb8ea55184acde55f05a48298f788ad443acbb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f94f15deebe55dd23352feff5087fb53d1baee1cf88b1fdfdba579c9391f43e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/git-town/git-town/v#{version.major}/src/cmd.version=v#{version}
      -X github.com/git-town/git-town/v#{version.major}/src/cmd.buildDate=#{time.strftime("%Y/%m/%d")}
    ]
    system "go", "build", *std_go_args(ldflags:)

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