class Harsh < Formula
  desc "Habit tracking for geeks"
  homepage "https://github.com/wakatara/harsh"
  url "https://ghfast.top/https://github.com/wakatara/harsh/archive/refs/tags/0.11.9.tar.gz"
  sha256 "0b8ebc8041a6b79c12734d6f4d7d5b411dcd979860b546f92b895e9b6c7bc8c3"
  license "MIT"
  head "https://github.com/wakatara/harsh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5251d5d14ecab8f331fdf112093f3e80fa97c12ba436fa147cb79e793795c380"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5251d5d14ecab8f331fdf112093f3e80fa97c12ba436fa147cb79e793795c380"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5251d5d14ecab8f331fdf112093f3e80fa97c12ba436fa147cb79e793795c380"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c5a1b44bf0c99b4f536c640bbb923c49eb260768b5ab2a627f91e08346577a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2e6ec99cc645584f3e68c3f57912e456c9de2a1c7735b1e71e3153b9a39423f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d26a853ae283497880c678d8863aa097e656aaa4229580189e6ad01f7da1e997"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/wakatara/harsh/cmd.version=#{version}")
  end

  test do
    assert_match "Welcome to harsh!", shell_output("#{bin}/harsh todo")
    assert_match version.to_s, shell_output("#{bin}/harsh --version")
  end
end