class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://ghproxy.com/https://github.com/bitrise-io/bitrise/archive/2.3.0.tar.gz"
  sha256 "ebafe04cb63dca03054a3f84d94feec437949f23972168cef75ee7f5f8cfea74"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e8d3f5a74e181c9f2917d99679b71a13b980dbba3ac1663c8a086a4ef5c91ab1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8d3f5a74e181c9f2917d99679b71a13b980dbba3ac1663c8a086a4ef5c91ab1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e8d3f5a74e181c9f2917d99679b71a13b980dbba3ac1663c8a086a4ef5c91ab1"
    sha256 cellar: :any_skip_relocation, ventura:        "c1855f15092bea2140214f8e632015ed6880acc647338f5f1bfecded03900c14"
    sha256 cellar: :any_skip_relocation, monterey:       "c1855f15092bea2140214f8e632015ed6880acc647338f5f1bfecded03900c14"
    sha256 cellar: :any_skip_relocation, big_sur:        "c1855f15092bea2140214f8e632015ed6880acc647338f5f1bfecded03900c14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07874eb971d1136991ff0c4a1ea5024f9671c44d248954dadfbba428c548bf90"
  end

  depends_on "go" => :build

  uses_from_macos "rsync"

  def install
    ldflags = %W[
      -s -w
      -X github.com/bitrise-io/bitrise/version.VERSION=#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags.join(" "))
  end

  test do
    (testpath/"bitrise.yml").write <<~EOS
      format_version: 1.3.1
      default_step_lib_source: https://github.com/bitrise-io/bitrise-steplib.git
      workflows:
        test_wf:
          steps:
          - script:
              inputs:
              - content: printf 'Test - OK' > brew.test.file
    EOS

    system "#{bin}/bitrise", "setup"
    system "#{bin}/bitrise", "run", "test_wf"
    assert_equal "Test - OK", (testpath/"brew.test.file").read.chomp
  end
end