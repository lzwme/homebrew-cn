class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.49897",
      revision: "fe6a888d671e7735583e113b8339cf240d2fb731"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "94cea908083000b37323bb50e8029b023b4120b644c681367e681870f807da6f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fab955c5a912892d3283c386ee91b1b358af357fb28c0b298ba38995c34a59bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fddd868b1b73545b28ea32e605ac0527778436b5a6a5bbedcebe15ea79d50eeb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c23f46eb650b1f6fe6d67a26ce480d3977702b2cf8e359b606b8e0697c1b9fb8"
    sha256 cellar: :any,                 x86_64_linux:  "e5e761854a5650b24529e2fd49c7e10bdedc860c10ce8fb44bfd2492cca37950"
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