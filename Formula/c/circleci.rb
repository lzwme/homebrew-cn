class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.49308",
      revision: "03db97ce57d7d6de60e4b9d41b15aa4ecf44b11d"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "15f55ebe325aa7fe8425ddb0716a41cd21f759ffdd3f186ad0c835115cb9de65"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30ae44c28a8025ba13c74d16d88744dcd8c8f36f4ebff446d63abf739e9b0158"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ea8a94c32ed67d2543ef1d1034b9e8ed9cd2f82cda61c2a6e201d89f21b5d99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d913d2e59ba49220b72ac29a394f401b0c9f7753cbc4000c42c11e8ff235d85"
    sha256 cellar: :any,                 x86_64_linux:  "98cc17831c6fde525ea1bd5acd0481ad1baaa1cbb9189805d0f434ebbf8c0ab2"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/circleci"

    generate_completions_from_executable(bin/"circleci", "completion")
    system bin/"circleci", "man", "--output", man1/"circleci.1"
  end

  test do
    ENV["DO_NOT_TRACK"] = "1"
    # assert basic script execution
    assert_match(/^circleci #{version} \(\h{12}\)$/, shell_output("#{bin}/circleci version").strip)
    (testpath/".circleci.yml").write("{version: 2.1}")
    output = shell_output("#{bin}/circleci config pack #{testpath}/.circleci.yml")
    assert_match "version: 2.1", output
  end
end