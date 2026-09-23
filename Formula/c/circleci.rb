class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.50961",
      revision: "f303824f6472bc4ce1048f3834cb43ce1627d0c4"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "79ffbd3415a90102f52333b91393ff45ec4fa6ec08a720ed3fb77a8d1baa1844"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a271fc96922de45d5c14d0fa14227a4ecea23540f68345baf5f8a7a29ac22a6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fc3ef14fcd23be4caf81432800864c9e1f20ac35fe981f5427768fa097984f86"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0b452384fc0b2cb79d4d0be3f18e27e9ebeff6a134e4c52cb507eaf44e626d3d"
    sha256 cellar: :any,                 x86_64_linux:      "e42ac96728203665cf0e86ff14be5e8201ed0df9a70d4bc8fe4ac06d5dc4b42c"
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