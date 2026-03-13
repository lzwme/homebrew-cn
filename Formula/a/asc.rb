class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rudrankriyam/App-Store-Connect-CLI/archive/refs/tags/0.41.0.tar.gz"
  sha256 "7388ae17c71674001b8bc6d4968971ab0941f80111579e19600a31d8070c66fa"
  license "MIT"
  head "https://github.com/rudrankriyam/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "682cd3122067de094eec1018640c280b2809682a8e39c0d9ba7c5b1f571d01be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31398922bd576d0a5645f273c1878455bf65baecc78cd5728b5f451ef1fd4228"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9aa5621f13d1e302c08723a065cdee6c73e0634323d5e1a49a33409be8f520f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "7186ec12978fffe08f10b1d7aa27c53e24dae45d97b00c724cd600d01dc62d26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fefe3a7de47eac49a66b70537643341d3e1c4bcf7b563da0e1441847687c4aae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c575279c71601acd7cf087aff1b439bbd8eda7f77a5cfda58fff7ceafc01b896"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end