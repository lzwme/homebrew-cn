class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.7.0",
      revision: "1df22bb0b7b64fe6c25b495cc33db53710dd3db2"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1b9c561e8f751bdfb340c8ac1cb10ab2fe8f92804ccd87795764a2dec6b38c91"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "509cffddc535c9021ee1a2bb3a4579d6c466bb11b2418f15818d60e9dd99ac9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9404022bf6f4fbc78ce914ff0773b28819076b9370859c8f5e30b9f555b70f82"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "15ac8dffe458c249e07c4d55b76668584da49e0aa95f3e6b9c6b0b9a914cc97a"
    sha256 cellar: :any,                 x86_64_linux:      "76264efab6c46f446ee1c90dd9793d46ce47503b88b114bb34f462c0dc95d202"
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