class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.48275",
      revision: "97d7a6b4d8d50f0393f5451be9da68c70a708f42"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "44d0010c8910057fc31edc1842a51daff9090191e5894660a77061b0de341940"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa1ef77ab24091df3dc1be968f52ca4148f44efe57dc927720b7485e0d17ff94"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29d7f5db04fc827a5c51bfdf07efccf02f7a8230972515a15a4910f5f6c496fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "42c33064da1258f65a7ef0af6c9aa45f8cf3a53adaa0d568adb5ecf6b4106604"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b29db8eb7aba0d400a5d6b5faea7231c62acc86197101222469a02c3f4b0b8fa"
    sha256 cellar: :any,                 x86_64_linux:  "e23ee06b500dac3c3d34267e2738b85b80566c2f738edb86608582f0ba3f112e"
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