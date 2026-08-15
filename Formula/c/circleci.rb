class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.48254",
      revision: "76ed0cc1b4dac024b9dec010342141764e16ff4a"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b41a5836728b50decd36a4a21958eeac92159476860ff95bbf767f13e7b30eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fea2f510ecd37ef26e71ded50644ec05fa759be9801fe3a5ede056518dde9d7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0dee8b8b5f938029c96ac1df7f961ad40411c322755887ea910a3d26ba23e16"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f9c2fbae86f2eb9956909fdd6b87d3015856d92bb4e49831f9f2becd0bb4c72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff89ae4ec82486dc4ff7a38b73f5bcb3fe8b8e78227ebce39fc43850b2e32d44"
    sha256 cellar: :any,                 x86_64_linux:  "2cb6426f638938a49e81ee56d2256448aa2c35bfc4e822e819e15ae5dee3e8b2"
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