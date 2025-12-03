class Tuios < Formula
  desc "Terminal UI OS (Terminal Multiplexer)"
  homepage "https://github.com/Gaurav-Gosain/tuios"
  url "https://ghfast.top/https://github.com/Gaurav-Gosain/tuios/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "c48ed7063d64d9ca6ae9d00d6afa167b961acd33113f54bdbedeeb702fa029a5"
  license "MIT"
  head "https://github.com/Gaurav-Gosain/tuios.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e3c7f3495d94fe2b3ac8292a967c9780dcfbcbb365f5369b6f1b007cbfcf97e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6825313f7081b45ed15ed8855da693049076ec49e97cca8245dbebcc1696067"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4490bd645e96e64a7ce323255efd05e2678f8849f655fa3f2ddaf881e69a5b7e"
    sha256 cellar: :any_skip_relocation, sonoma:        "8360dc4c94b44e285f5e944ee5050fc95f707a4dca4b9227857ba405b028840a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2d04afae2ed4f2b449127847965db232938c3e0ce4197d39c6a6244aad0b137"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b22604e63fe6648731a3c6633f1d8025da47de584aadaaa07d5060d657e72b5"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601} -X main.builtBy=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/tuios"

    generate_completions_from_executable(bin/"tuios", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tuios --version")

    assert_match "git_hub_dark", shell_output("#{bin}/tuios --list-themes")
  end
end