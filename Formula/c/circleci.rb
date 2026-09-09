class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.49698",
      revision: "3e9e3e7da2bf5a4fad0d5e9019f9ab121b214388"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7411eb5746f5c9b283b0e8cf90e6e60d8359071e95c667ccab4e6ad5a53ae97b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02fc9dfcabfb2e1672f768616708e0da4d6840da39cb57e33ed6046bf7081761"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57ac738c972ebdfd6587bfeb24b29004f93cc9271d98f2143fa76843b024b7ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e43a22d3994d36db2db604d9a4f6e0412ceb386c5101bb25fce6a3ea5ab692ec"
    sha256 cellar: :any,                 x86_64_linux:  "4cce2d7fdd8514c81e1dd9f38e7b7d8f23af319264b053dc7195eee6a981aac9"
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