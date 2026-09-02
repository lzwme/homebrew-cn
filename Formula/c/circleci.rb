class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.49221",
      revision: "99cc7ce61c637a4a73171b667836f9825e268555"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b37e03ab2d5148629fcb55df3ef5c02c695e82aed755d4fff91236503e363aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8f9eb88ac9ac912e7b21c3b61aae6e54894da1da031234eaa376b91029b27dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a8301633e101439fd72e640496afaea0fd41942d43aae0e68e2b2b0b9a2b066"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d9761d876f23a0c4b21234ba318bad18a6e434c7cd728481399f75458c741ac"
    sha256 cellar: :any,                 x86_64_linux:  "9808a27e83ae6e894c8ab798a188a31f65fd668acff60fa1ffd433c7cfe7a9c6"
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