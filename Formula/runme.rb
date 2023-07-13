class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://github.com/stateful/runme.git",
      tag:      "v1.4.1",
      revision: "364109390e5cde1ee94631a4566b13625ab27eb5"
  license "Apache-2.0"
  head "https://github.com/stateful/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "730b5a4247b6a680a5cf0c2ffe0b205f0f84b01fcf7d2ef21aa180ceb9416a42"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3e809f4e7f91de8318d12df1be49d0e6aec9d5a277978d0b4c87d0d98452247"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "506cb8d4eb121c94eb30804b015b0dca25f0240f27bf90507ffc3d29a8b05a83"
    sha256 cellar: :any_skip_relocation, ventura:        "0793c79e93df995a0e2c06eb1c22ad2d61128b8d06562475cecd00a7240ce5e1"
    sha256 cellar: :any_skip_relocation, monterey:       "0659ae9554bd1b1436ead4bd4fb7ff1184b7c12e748ccab88fbcc2ce00d7192f"
    sha256 cellar: :any_skip_relocation, big_sur:        "261a6949002e983dbea1e700511f15b79ac8ebaf6c26d1edb08de34b72d26a23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84498321202548ccdddcdec40571a661cd98ca191b1021c01d7d3f1834c6b4b9"
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