class LeafMarkdownViewer < Formula
  desc "Terminal Markdown previewer with a GUI-like experience"
  homepage "https://leaf.rivolink.mg/"
  url "https://ghfast.top/https://github.com/RivoLink/leaf/archive/refs/tags/1.27.1.tar.gz"
  sha256 "17ef2e5ae0abac73e8ceb3da4b5756ef1153d001b234eed3df53d43c6cfa1ccf"
  license "MIT"
  head "https://github.com/RivoLink/leaf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c8b49b580f0d56348b94d75bfc2b1c4796a1a0209f69c1534963f31a2c29862"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "782715bfc75883e477ca163d0509f5f12ed7a6f29a4b64094e3dc3b08da404ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10bbab3acc3f68633973a66307fd2ed891905fc7495180b9bd3d5403092daea4"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b0bd6d28807f8d918a795d51a9c36f15aade5046f26dc8f865db0449771eb69"
    sha256 cellar: :any,                 arm64_linux:   "15e056d52bcf04552b72061013b56991dcf352f5d58fedbcc279fe7da30ea176"
    sha256 cellar: :any,                 x86_64_linux:  "1e551c2d2883be0233c0c96add8e54201789bc8e8da14cd084d48ef2eeae2f38"
  end

  depends_on "rust" => :build

  conflicts_with "leaf", because: "both install `leaf` binaries"
  conflicts_with "leaf-proxy", because: "both install `leaf` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.md").write "# Hello\n\nThis is a **test**."
    output = shell_output("#{bin}/leaf --inline test.md")
    assert_match "Hello", output
  end
end