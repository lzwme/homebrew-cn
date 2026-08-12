class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.47876",
      revision: "4ea36161842a0cd5157c7340dd9ddec6fb2001be"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e020bb386a318092e52cd83adb5e41b45817cb7ccf4009a2e7713f59b413676"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e98dbae780761694c7de18dcbd6ef5f23b26e5308eab2d2d51952e7270581302"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2fbc1cf7f71c99ad503a2f58b148b9337908da34b221d337f6354c27826fedf"
    sha256 cellar: :any_skip_relocation, sonoma:        "f327505e7cb278d31c999cfba40bdf12d8da5cc82b13a13fa401ace741464ff5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8241dd2f21381f645b214faf3feaf3f818d4e56384a517f57fec66c9c998753"
    sha256 cellar: :any,                 x86_64_linux:  "7572ef6db3753f22687e7a25c83abc1a48abd1de9f0e86c39ede08219e4cbe3c"
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