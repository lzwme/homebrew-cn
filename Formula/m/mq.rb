class Mq < Formula
  desc "Jq-like command-line tool for markdown processing"
  homepage "https://mqlang.org/"
  url "https://ghfast.top/https://github.com/harehare/mq/archive/refs/tags/v0.5.8.tar.gz"
  sha256 "e95e21d6d24369a4402b1dfe14d0dda7c68a5a3e4259036aca62995a8afd0425"
  license "MIT"
  head "https://github.com/harehare/mq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3655a06b54523697fa126faa6a6680582c97fe3836340cfc10b9672aecef6f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9aafb0a51551cbc0655f0bc643a5d32f8b4c4842cbdb1e5f4be6536d3d8897a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e41e14385e9f0d631b5b1b1ecb775180fb8bc8caaa0a14fe4505189850202d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef828cd0ad1d0f115518b1506ab4edad2604e0329d446c1295cddc2b519f7245"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d067e5e746ec1c4ae8fafd3275d096b837c378d9fc68fe0697985a61b4a7438"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "324b5a36e20651fd35847d82430a87d318c2ef587e85f92887441b933cad5426"
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