class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v2.18.1",
      revision: "9fa2a65578f357f21fc3f3035ff96ba9e2890ad9"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7370caba84a1da059a9af202ba09d544832d26454eb5700798635424b3b20bc1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0abfe03d9686cd6cb94fb38c030d212a012e242fbcf342187454c666e784c147"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "28a5fa890321ca8fedfc31e0998c0e1fa00a644787d48a420b8b902723a04ad3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "1087c3bf0dc9e08a0f0e9c97ed5936d2a479cbff244a640173fe1f551ff1d325"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1727f276e2ba8ce7c6e475d8c0dad0c3d0db5e2c5735f9c16f3b5f8db5c22ed7"
    sha256 cellar: :any,                 x86_64_linux:      "7fabc937a70d3b4fc153da55f5c5eeee3cd01cafe2cf84737426c516af90feeb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser)

    generate_completions_from_executable(bin/"goreleaser", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "thanks for using GoReleaser!", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_path_exists testpath/".goreleaser.yml"
  end
end