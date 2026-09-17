class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.50624",
      revision: "fd463dd7de1fe40110d0e7c81aacf567b8af811c"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8a582b28e9e97543b937b16b2cbefae272b4c1b0bb74cd18c92c4fc6ae2881de"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0c1b3366b9eed428ebe8735bd8dd28db1844695c1b2e0715ee20c39d1313b8e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a2b83ec8c8e150ee7071ecc173cbe772e3d4ff2bb23663da50478f6196af6ad7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4fd0a2a5629b30308ea16824b0e9304d69e0563078cdc25b35f3638eb8044a77"
    sha256 cellar: :any,                 x86_64_linux:      "3945d76029de14351e73296066e1907ef883a7566514bbd415e26a02960d097a"
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