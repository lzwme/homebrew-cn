class Mq < Formula
  desc "Jq-like command-line tool for markdown processing"
  homepage "https://mqlang.org/"
  url "https://ghfast.top/https://github.com/harehare/mq/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "bf3611864081c9d4ccd8f3fa3c9f841d4268ef3c3e22fee6c06c9923f54db148"
  license "MIT"
  head "https://github.com/harehare/mq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7ea8c98c9e21a15f5111336ada7bd06a34ab9ffb80e9af6467a496d78c9ad0d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "596dc1af66ee5db77adb1f7eb4206f8003ccc51d1d1971efde592b97c0c5c68d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01ecfa832dc1290665afc9c4b741bb286f6c4d308af9086c0b13e50ad544ba39"
    sha256 cellar: :any_skip_relocation, sonoma:        "05a55114d5e4093541606738da89481b135c3584866420d7012de4c65c2911c4"
    sha256 cellar: :any,                 arm64_linux:   "5964513064a03d6047db75cd38a568180988e6489a293a95ec42a09db2d902b9"
    sha256 cellar: :any,                 x86_64_linux:  "515288c435b63743cf34681a4a2e6c81503dfd2088ce43db85a6dcfb7591135b"
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