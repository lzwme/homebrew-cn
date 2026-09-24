class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.51305",
      revision: "e60bdd56f82318ce81de3c448e4dac13362bbf84"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2e151c64106b8e8367393ebcfefe528c798200eb0a4e030e9587d6f4b764eb18"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1c2047a8be155c531aa8667d08ac369c457ccf27017b7f066ac6d8053192afb7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "934ef223bc751fff9bfbf2eeb3d5668e5e0948ed9bc1487164da13ee796bc018"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a530b53fb960deb40aa3c72f8215de5184ba03fc78b3d470c55af58c8d286fe0"
    sha256 cellar: :any,                 x86_64_linux:      "b67c8e17d99451a9fb3423915fe9d3f96057857914f859a6a1cde10dc4834d3b"
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