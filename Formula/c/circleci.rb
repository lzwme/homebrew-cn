class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.51648",
      revision: "0ee5af2e58d8a25799e48e17846ae3eb08957db1"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "96fee69f1a0c26043b420681759fa59d50187fad48ee73cf12f096adfce9fec4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "939cbd7b63943d4df8330f4aaeaf95700ba4ee55a5ebbd2d753e2a97bf794be8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7ac62491f9ab62c3ec09232cd7434fcacff0002ced79fee4aa8b889d6d3942a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bb6e1ceb0fa3f6a40388525b04f8493e4fa81bc2bc567af1da359094d58e56f9"
    sha256 cellar: :any,                 x86_64_linux:      "d165cb0d7190d08dd5e762bc99e6dbb338774c26e9240d23160c44c793a1c6a4"
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