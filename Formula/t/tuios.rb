class Tuios < Formula
  desc "Terminal UI OS (Terminal Multiplexer)"
  homepage "https://tuios.dev/"
  url "https://ghfast.top/https://github.com/Gaurav-Gosain/tuios/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "bb65dcd4ae5a8e2421260de91172ac84f4f944e3909569cef221fe51533af930"
  license "MIT"
  head "https://github.com/Gaurav-Gosain/tuios.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "43c49c14b5dfd06c1796417fb4fd5b6f91ab5142f486009651c59996d5f20978"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f06de78582d5f54f21a10152892057343aeefb9cb9ca9e082c6ecd36068af49e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6635e3fb4b4b6fb8633f0d283451588f4e740b0d2543817f386241ffad3c8c05"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9acdc201102ab5c0c66d771c582e91a3f138e014b51e2f12b934751349f0bfe1"
    sha256 cellar: :any,                 x86_64_linux:      "3418c0a49b739240cb3b50dd36b4693b1ba61271a47b8bbb6e5ee902a71dcbcb"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/tuios"

    generate_completions_from_executable(bin/"tuios", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tuios --version")

    assert_match "git_hub_dark", shell_output("#{bin}/tuios --list-themes")
  end
end