class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.6.0",
      revision: "6ad3fefd1e17d23b0aefd77a406a69dceb1606c1"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e2d48b7e44d708215e996cb8f7651128151607bae0cb526d464ba8032c8d67ad"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8d59d02f96faa5a66c4a304bfc9002bacaf4cfd1a82177c35f632a69b353f862"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1292ff88aed1dc7a314e2e931160958f9ce69d22d237ad3f6d53bcf50e5cc211"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1ba35eacc9e17cc81a2c073232fff2d1087ed8439fb699408984de87c6b9d6cf"
    sha256 cellar: :any,                 x86_64_linux:      "936f0e5cd785e88412397052e790c648dc97fc5bff031d304153556fc6644abf"
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