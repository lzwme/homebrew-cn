class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.50462",
      revision: "5ec656ee632fd158e31dd6210a22642b83e482ce"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0bcc4b51da0f760c0257faebf3e7920509df03b422338d2f27d0cac6cdfba961"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cd8c2b60fe32245f443ab05fecfafabbb4b314717919b540d7112805527c12a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "72fca761e0598624c548e7c8c51693ad7754b68bdbaf14d25394f3ea11dadd89"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "687602b865c826912423a1a06cf29c0338aac5c57828cd8b5b00d85789e682f7"
    sha256 cellar: :any,                 x86_64_linux:      "716f67d1b8194f04eef0458888ecf13e2f394cb9e36799894a6032c99e0dcba5"
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