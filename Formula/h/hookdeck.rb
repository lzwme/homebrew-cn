class Hookdeck < Formula
  desc "Forward webhook events from Hookdeck to a local server"
  homepage "https://hookdeck.com"
  url "https://ghfast.top/https://github.com/hookdeck/hookdeck-cli/archive/refs/tags/v2.3.2.tar.gz"
  sha256 "7604e97fbe4c9f3ec16ca9d17611deac93d8d0b10998c2386b042ff65a60feee"
  license "Apache-2.0"
  head "https://github.com/hookdeck/hookdeck-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d96f2d973a195c272a54acccf0384463b3027ae436a6c117299510472231faf2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d96f2d973a195c272a54acccf0384463b3027ae436a6c117299510472231faf2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d96f2d973a195c272a54acccf0384463b3027ae436a6c117299510472231faf2"
    sha256 cellar: :any_skip_relocation, sonoma:        "54fffdf2c90f518189e9a30f45780c45ac1397fadcbe8fcb069b0869227dbd8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "312db78d7397ebb0f60eacc6660666aa84c8f83f1aaac05f65f7e22303731cd0"
    sha256 cellar: :any,                 x86_64_linux:  "9c578471ed56263580dcd517c25b72058a73924af296ae9118827761cdecf057"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/hookdeck/hookdeck-cli/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"hookdeck", "completion",
                                         shell_parameter_format: "--shell=",
                                         shells:                 [:bash, :zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hookdeck --version")
    assert_match "Provide a project API key", shell_output("#{bin}/hookdeck ci 2>&1", 1)
  end
end