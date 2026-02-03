class Mq < Formula
  desc "Jq-like command-line tool for markdown processing"
  homepage "https://mqlang.org/"
  url "https://ghfast.top/https://github.com/harehare/mq/archive/refs/tags/v0.5.13.tar.gz"
  sha256 "217b4b293a4d04be55d15712c31c9251d7a13026b7e86f64339356ec7164b969"
  license "MIT"
  head "https://github.com/harehare/mq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "191e97d79bdefc0ed3f34e2872ad5293e12c0645340fe7ca8923803118cf8ff1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c93e0fb4b646660d1d580dd369c593e0c61a9b9706ae5a97810f3e4e8f14473a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00c12a250047121958d90319b010aba3021cf2fe0c8a1f6876802aedde3abec2"
    sha256 cellar: :any_skip_relocation, sonoma:        "0bf2b728dfcc3356619817820f8b0f922ce46a634e6b852da07531883c2d0767"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca4d16bf1d131ed7e4b9b60d72a3bdc2c9feaca40fe6486acb24a026b5295fc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c87ba9af0752636533956cba2416bc15d563c011d5c0d6b66db055ce15082513"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/mq-run")
    system "cargo", "install", *std_cargo_args(path: "crates/mq-lsp")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mq --version")

    (testpath/"test.md").write("# Hello World\n\nThis is a test.")
    output = shell_output("#{bin}/mq '.h' #{testpath}/test.md")
    assert_equal "# Hello World\n", output
  end
end