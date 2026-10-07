class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.2.0",
      revision: "6aec145c085f09fb66fc95339d57488cbb19e7fb"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f605f30a58c941540ea07d8cae1609f90ecb261406991d87380e1e0448617fac"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b192969aade177ff92fcab3a7640d6f53f3acc3fcf527152104a73e4ef0232b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5fa19c52678069c6fe4d835617cad400955d7d2f16f811d0bc43999d2aa7d8c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "027269f80e83acf435ccc24a46db5c759bbf896698e97f6abef4e48f785904d8"
    sha256 cellar: :any,                 x86_64_linux:      "39738751f7dc213c769505b4f36093592805b0cf0cd478e32059eb2941be8037"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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