class Rtk < Formula
  desc "CLI proxy to minimize LLM token consumption"
  homepage "https://www.rtk-ai.app/"
  url "https://ghfast.top/https://github.com/rtk-ai/rtk/archive/refs/tags/v0.37.1.tar.gz"
  sha256 "974162905a5b49d31c1abb1bc02ec87baf4f76425869a6ad1448862745135060"
  license "Apache-2.0"
  head "https://github.com/rtk-ai/rtk.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a437b23ac04142424567f348b0ed37fc171d92d627606c9d0de25fac7bcf3b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3975d074a038ed3908344ac52777a084ec5abb1a5439d0486e135bccb8693227"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63e36920c12c1d9a82bb5d7a3202ef5785160d6634f8c5d7744dcd475ab75e3f"
    sha256 cellar: :any_skip_relocation, sonoma:        "18171960c61c1c9e2d3127da2d41db5543f72f3a56d543bc14ccdeaa7f1dc437"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27f4d1afcd624beb8b84a71a86bb0f1f4a7ad03d5050328144812bd10142aafe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83698761abe061d1881b61c8005891c0a21913717b78e91240bf72aa0c77d511"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rtk --version")

    (testpath/"homebrew.txt").write "hello from homebrew\n"
    output = shell_output("#{bin}/rtk ls #{testpath}")
    assert_match "homebrew.txt", output
  end
end