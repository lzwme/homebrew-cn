class Comrak < Formula
  desc "CommonMark + GFM compatible Markdown parser and renderer"
  homepage "https://github.com/kivikakk/comrak"
  url "https://ghfast.top/https://github.com/kivikakk/comrak/archive/refs/tags/v0.41.0.tar.gz"
  sha256 "0f80341d6da8c2e5713521c8442b123fd06c1a04d5602fdb217c4ec2ec2658f8"
  license "BSD-2-Clause"
  head "https://github.com/kivikakk/comrak.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a9c053269e567c3177de519b04dc7f5e5aba60ccbbf655b34c4028c9b638550"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13b4055349338654073ff972a30dba306aa1a13bce39a0aabcea098af0c49822"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a210fc0eb28bbcfd4266bcf269ef5130e9fe9a0690107dde4a32784865ed9ce3"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ae55024d5a22a0eb139dde2637980553b916af52f6ead1eea3a62bd0b951a11"
    sha256 cellar: :any_skip_relocation, ventura:       "a17fd1c2cea9f4e2e2c41ac4358a6a2b98584eb939ef4984ef1de28b864ff9ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ccd8c2870ead06950f2c436369377e8d830510504ae46012a7e7c1c65fb833cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9341cd630ed97b72dc0e1664aa4d0ce9074cec5e7b6d3c2725f92ad879968ef9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/comrak --version")

    (testpath/"test.md").write <<~MARKDOWN
      # Hello, World!

      This is a test of the **comrak** Markdown parser.
    MARKDOWN

    output = shell_output("#{bin}/comrak test.md")
    assert_match "<h1>Hello, World!</h1>", output
    assert_match "<p>This is a test of the <strong>comrak</strong> Markdown parser.</p>", output
  end
end