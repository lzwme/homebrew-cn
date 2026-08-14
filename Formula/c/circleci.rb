class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.48122",
      revision: "a00439e32dcf321e977e07d36a3b681ce2ad6539"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b4d22febb328360904f8923a52ecbc43ab5b69948448ef72a1f45f1b4f772827"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb9ad869070b9af8bd27ed7edb607266b59de021ffa990956d98590fd859a403"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8893cf722f2dfcaa932d0cbda8f9e3a89fa521f9746b78b8a94da328038c312"
    sha256 cellar: :any_skip_relocation, sonoma:        "4500f0223a365c42de8662bb9f36b876b6b7c0f4728cedd9cc36d9f6c6980495"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4003d092928eb0a91068d090271b6b80395c50855a6d0db22d4d2789606d4ab1"
    sha256 cellar: :any,                 x86_64_linux:  "27a0d253c8355491aca60d2ab165566b93fa73dc996b3e80519247b72d23d1aa"
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