class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.48658",
      revision: "e6a42155d60857bca821ea3037535f69a2da52ac"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b55afba72122d7a28945f00b6c49b49d53f8034a3915635679d22dd6d7593192"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57878c46b4796e0870aa44bd52528542242026de3edcddd1d4f1e790a9b9c11f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be84277f07853c528e819247b5059e9af9d5ef5ea46fa43d6f73079ea84a9a82"
    sha256 cellar: :any_skip_relocation, sonoma:        "30ab7938f1c085b43af7212fd06209a407d0c5b6bb6e6e478ef0b5c7416a49ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e85b0fb0dd10eee4a4aa5bf95ce5613c444fcca6f903afb0bc31f498436b0288"
    sha256 cellar: :any,                 x86_64_linux:  "039cdf82a9340cbcbf5c66eaa51becd560c7ece27dcc1f0cc34944f493a150a5"
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