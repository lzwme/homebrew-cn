class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.49536",
      revision: "a4bcc413d3e14db520992be69a88f79925cdece3"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10c1f321978f82ce053898dc958cb388ff7bad1a886598fe333dd5c164580141"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22aade24fd3d1ee9468f5193734e706fd29834eae98b1c4adab574806b6da718"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15ebfb6c3820a7997fa1535c3801a9a9504802866ca8933e24ba7dbf5f65bd8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "035cac02664a9b39ecd2a7f0b0fb5a22a59a6ad1af14ff9c096c21381489e8f7"
    sha256 cellar: :any,                 x86_64_linux:  "ec084557b1861805b10c32d66e8cc389b119112d7a3c805de9d7d3b5e5d38fc2"
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