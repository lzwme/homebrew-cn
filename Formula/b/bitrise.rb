class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://ghproxy.com/https://github.com/bitrise-io/bitrise/archive/refs/tags/2.6.0.tar.gz"
  sha256 "4ca408ad741f65fece02224aba4c066adc76844285716f837a1bac6ccb6c116d"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5deddece42751400fdb59de63654c1cf23a9379d5e5e9983e1a0559c057b28e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c75f2d6b3f8a5c183236ae74e58ab9992b672d1f53abd89aa1fa41e498a3e1fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "637180ebda7d4cba1ca43e9a0a4841db488ec613a688abede923caae00e476a0"
    sha256 cellar: :any_skip_relocation, sonoma:         "d09e9e06342758ddc37c8d5bc242854d34286fa493560647bf5f86941a60f88d"
    sha256 cellar: :any_skip_relocation, ventura:        "388d9ab3986293d9f144cc17bb83ac072b9a0239f1affa552b53a42f67d7169e"
    sha256 cellar: :any_skip_relocation, monterey:       "ef5ba5cc47cd8d5025133be7ecf8f3626d6c912bb269f6bb9ece80f5a6af4536"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "453d9262a529de5f28156f7c9f727416acf0f97c9a488bb2221971c3136dc988"
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