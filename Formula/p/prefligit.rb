class Prefligit < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prefligit"
  url "https://ghfast.top/https://github.com/j178/prefligit/archive/refs/tags/v0.0.20.tar.gz"
  sha256 "39bf83c0ba1048100ec8ff92003f612e5ec42f28ed23191f6c868b89c614b454"
  license "MIT"
  head "https://github.com/j178/prefligit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4955f16264fb978f07e0c3639023ce9b3b804c800f544bc84d97903e84d303b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52f80ab4a7bf900a92baaa69ad9a640187a87057dc21e658025f4a2f09a1c6ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d93f866551a7bb4a41314c8596fa002cc1182d090ac4a7fd08fc990eac6a0198"
    sha256 cellar: :any_skip_relocation, sonoma:        "14769a55137257dff71ace1c2998ae25f0b42884338c9150f7ba4068dfbe2ca6"
    sha256 cellar: :any_skip_relocation, ventura:       "e5b544f9c06b06f18c940153bdea8918125346ba339a5e890ecf25173ccd12b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5baf0dc7044d4643573e1cc94b6d85794816624a693e69a41049801d6aeb70c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20881a69bee5a72ecc97a9d4f4eb69930bcaa5ffa5aadc04b6241ec6b4d3039b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"prefligit", "generate-shell-completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prefligit --version")

    output = shell_output("#{bin}/prefligit sample-config")
    assert_match "See https://pre-commit.com for more information", output
  end
end