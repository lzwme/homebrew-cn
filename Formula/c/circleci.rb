class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.48490",
      revision: "29450bd6f6eb821d03982434beeda9910e8da511"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e250ac100a9d13102f7152f7bec29c783a6e1a8c9d8cebfd5c55d495db558ccf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c24d9206c9d6b8fc29f457d0da4c76535a48cd0422883f3f6e16f035d535080"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f37157f253be12953f197efeef3cc2420d3b4602e75e795b34ca98c0cf8de5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "1cda193f125eecee9d573cd65e64a38b54bca46292abeb9466e5e31c568ee06f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a66f7c581c4f83f2e7536ade7920bd6d1aa997dbbed602c85b98e8f0b6b63a70"
    sha256 cellar: :any,                 x86_64_linux:  "586239356d91a2b977f3058fd30486d96e08f7555c320341b0302260dbb9f8a4"
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