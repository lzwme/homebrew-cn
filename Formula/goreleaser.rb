class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v1.17.0",
      revision: "ffefd6c4ae257d2e9aeccb5786ba66401cc1bd78"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "487718ef88fd858c01113f7fa8e56d7bdc37d67b02a1302c0f5d5e46a5aacad3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "487718ef88fd858c01113f7fa8e56d7bdc37d67b02a1302c0f5d5e46a5aacad3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "487718ef88fd858c01113f7fa8e56d7bdc37d67b02a1302c0f5d5e46a5aacad3"
    sha256 cellar: :any_skip_relocation, ventura:        "6c451776af2da6683fef79d9e38ce90677c3e8c61db26b004a83cd84a575cf8f"
    sha256 cellar: :any_skip_relocation, monterey:       "6c451776af2da6683fef79d9e38ce90677c3e8c61db26b004a83cd84a575cf8f"
    sha256 cellar: :any_skip_relocation, big_sur:        "6c451776af2da6683fef79d9e38ce90677c3e8c61db26b004a83cd84a575cf8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb32bc4cf14d5a4168c4fa9cc3aaf5a90acbadeee5d07007cb2a0a9685af28d5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.builtBy=homebrew
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)

    # Install shell completions
    generate_completions_from_executable(bin/"goreleaser", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end