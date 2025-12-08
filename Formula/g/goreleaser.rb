class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v2.13.1",
      revision: "706905505d944237c24baff543def8800f295c2c"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ec228cac8ac0b45642e9ee3a7afc1f1e83b0bade8730fd54db1a7e461834655e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec228cac8ac0b45642e9ee3a7afc1f1e83b0bade8730fd54db1a7e461834655e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec228cac8ac0b45642e9ee3a7afc1f1e83b0bade8730fd54db1a7e461834655e"
    sha256 cellar: :any_skip_relocation, sonoma:        "36d96be01ec933e6cc62246ee5785007c57b40903574cdc9f88f577d7d82d8c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1449b9e608d0ad6ec2fa0ddf8697c05acfe8320b20f0531cd33e4a5de789b26c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47d720e6fdb44b2883d96ae941de49ecc63a742ba437b1e358d90b85642bc45b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{Utils.git_head} -X main.builtBy=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    # Install shell completions
    generate_completions_from_executable(bin/"goreleaser", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "thanks for using GoReleaser!", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_path_exists testpath/".goreleaser.yml"
  end
end