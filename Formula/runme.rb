class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://github.com/stateful/runme.git",
      tag:      "v1.3.0",
      revision: "da4fb8ff2264ad7765eda78d9ad5b125b0e6284d"
  license "Apache-2.0"
  head "https://github.com/stateful/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6deab5d3a6e0f6455a7de1344b2ae293054143742730ddd2eb1317b2ad3072c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "050a99f3c51dcaa3fd42c807b83d8a2bdefadeba90248d7eeb1cec450885f3d8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7650642dd7e7628af46a1b27a380b2b5ed606996f12161d339fa0aeb599ff2da"
    sha256 cellar: :any_skip_relocation, ventura:        "92e66ed0c275b2bb91b33bf7e8313a50f3f6b38d64e73463f6c81c1dc64e1362"
    sha256 cellar: :any_skip_relocation, monterey:       "421de20037f267d8d7168676ab58a91ffe78058b1f7c7c8aa8cc2f750fe25495"
    sha256 cellar: :any_skip_relocation, big_sur:        "35592e25705f1b5227980c2ec7e5dec8aa0bd1602cff1318a2c72f6cfb4bc435"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eaf1c8ad85b2c7c5402c1df32a7efca9ebe7530cc5b824fb1e0fa27717b5b5a3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/stateful/runme/internal/version.BuildDate=#{time.iso8601}
      -X github.com/stateful/runme/internal/version.BuildVersion=#{version}
      -X github.com/stateful/runme/internal/version.Commit=#{Utils.git_head}
    ]

    system "go", "build", "-o", bin, *std_go_args(ldflags: ldflags), "./main.go"
    generate_completions_from_executable(bin/"runme", "completion", shells: [:bash, :zsh, :fish])
  end

  test do
    system "#{bin}/runme", "--version"
    markdown = (testpath/"README.md")
    markdown.write <<~EOS
      # Some Markdown

      Has some text.

      ```sh { name=foobar }
      echo "Hello World"
      ```
    EOS
    assert_match "Hello World", shell_output("#{bin}/runme run foobar")
    assert_match "foobar", shell_output("#{bin}/runme list")
  end
end