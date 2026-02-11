class Mq < Formula
  desc "Jq-like command-line tool for markdown processing"
  homepage "https://mqlang.org/"
  url "https://ghfast.top/https://github.com/harehare/mq/archive/refs/tags/v0.5.14.tar.gz"
  sha256 "a22eec7800d7352597eac109577c3258baa4c9572513216b13a65a2835a29182"
  license "MIT"
  head "https://github.com/harehare/mq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be838fd848245b999b5a621b063fce5f75b4ba387dadfe8e23442995213f887a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "862a0ab6af3c8b468e59cd832031eb6b782882ba7584dc0427f3efc631ab1c45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e76d2f580e8f0f5088d4fe4fe805f98ca7dfb8755570482fb1f1dfca3f4304b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8ebe293618ead5ca78270ecf503c5182c5d85fc63fa9b4bec33e6aadb141f62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94223001dc6419a6edfe1516097e13e1005aff32c2934215ff9374e6a9e879b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb7475d2a63979fcaa6ba7c7616c842bd8d5c05c4af9b68d6529bb2ae5b3e131"
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