class Mq < Formula
  desc "Jq-like command-line tool for markdown processing"
  homepage "https://mqlang.org/"
  url "https://ghfast.top/https://github.com/harehare/mq/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "1f1b1d2a5d870085a0d0cfa4e812a963855970c92c288162d75c3b861cf1d320"
  license "MIT"
  head "https://github.com/harehare/mq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a7d82989c54a1b3c745fab8c01228317173a008bff210b8ffb8d44ba3d714b33"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc655493e3dfeb8e8dc36627ac422e2af572f66198de9813be69eb5785b23a2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "613e2a69ea67c4210f25746760953f75f615c2f6d7f5b5337e8c5f23170889ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "9fbaa202ab2c51a0bfd7b417b9cd2f39fe4edea8d85e2dd69f2af8af9f4dcba2"
    sha256 cellar: :any,                 arm64_linux:   "dc7b89dd1aa8aa5ca90ce2e67c9c2df08169c659fd8eef01ebb873ffea9d6a50"
    sha256 cellar: :any,                 x86_64_linux:  "799748f5f5d48c3aa44a996f5dcc9968ac5859a14e6df1485396e4d06ed69acb"
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