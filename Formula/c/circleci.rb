class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.5.0",
      revision: "b60dc4c63b65fe080d3664ed993765dfc201bb11"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6c139fe1c404483a97307dce5c0a73ef1e53a6b2aed9e2fb7ca8deed47fe1f31"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9fc29521448b05738e22b3cfaa529f0f2462375c9fde093e508f78185596ff6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ba54ef49a346153bc42d7d6ef97eead5b309655b9e3936949c478aae69c02d75"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "991f66c27353689393897a0aa06553afed05f2ca55d6d052539949959b405ca9"
    sha256 cellar: :any,                 x86_64_linux:      "7fd2802fd6b099c37d01710692600fb813977bb43965d9d4f3194d4e679285c9"
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