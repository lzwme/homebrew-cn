class Mq < Formula
  desc "Jq-like command-line tool for markdown processing"
  homepage "https://mqlang.org/"
  url "https://ghfast.top/https://github.com/harehare/mq/archive/refs/tags/v0.5.12.tar.gz"
  sha256 "b5b8307a312463d7602255d0c2fe003c19ece2e46a0efc1d013d30c7be0846c6"
  license "MIT"
  head "https://github.com/harehare/mq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b004634015936a8211ef6b7942a4665e3be3cbada7307c5c215b8b6f7b46f38b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01173fe3d93f0432ee8878ccd87e65d7a8832fbc44a284e1550c0e5dbc1bd2b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91c5e5298ba3bef0c19ceb2aa4014594332051ea1a3db2af4b8974fa2fb84482"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b5294f022842f19d2e615470c5a9a9db2c44955c9b06f24a6ce4ea1a2251286"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2a5feefa814ddc345effac4793710cf67874aa4c3d9ec7864ff1446ce2c0a08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f3fe7f6975abaae14681f0cea25fcea48d4bdc6ad33d5b38f9fa17726085c60"
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