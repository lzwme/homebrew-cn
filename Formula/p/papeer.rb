class Papeer < Formula
  desc "Convert websites into eBooks and Markdown"
  homepage "https://papeer.tech"
  url "https://ghfast.top/https://github.com/lapwat/papeer/archive/refs/tags/v0.8.5.tar.gz"
  sha256 "bfa5ed66a3622b51b3462a629b01327d335bc56716f700ad97a5f4b521bcb94b"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6a280ac7dee6b5eca6178ea2f990a38bc2ff9247078225df0d7319f8c86a7b8f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a280ac7dee6b5eca6178ea2f990a38bc2ff9247078225df0d7319f8c86a7b8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a280ac7dee6b5eca6178ea2f990a38bc2ff9247078225df0d7319f8c86a7b8f"
    sha256 cellar: :any_skip_relocation, sonoma:        "70280701b43e2af96cd8c072468d86c80bd6391fb62f4a101984e2a0c573254a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1414b27227a341e24fbdbea2d7910b4ecb68dd5d1ba998e01f5fe3253cc17ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "984bae6b0bce278e01a5286f847840f540150b9523f9a251dad801242864ff44"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"papeer", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/papeer version")

    output = shell_output("#{bin}/papeer list https://12factor.net/ --selector='section.concrete>article>h2>a'")
    assert_match "8  VIII. Concurrency", output
  end
end