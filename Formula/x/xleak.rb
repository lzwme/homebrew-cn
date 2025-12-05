class Xleak < Formula
  desc "Terminal Excel viewer with an interactive TUI"
  homepage "https://github.com/bgreenwell/xleak"
  url "https://ghfast.top/https://github.com/bgreenwell/xleak/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "fe3532da7980f9a0b74c7d5daaed44865fb3bd65bda84e9d3c690a019b44f6d7"
  license "MIT"
  head "https://github.com/bgreenwell/xleak.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bef72cbb6bb1a7984b5d09133e036843eec5eaa8787817bd2690bacc2b726bfc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47547298db308efb9f95968b341ef9261cb6cbd5d6c10a2f0ccf736d68f059d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8cde0103694fb7c2e31e1a6901639b0cdab783f5c82a15c10755f92eb1606f0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "27aaeb456b311fb8df0b1cd330808b67f752d6f1d0b5f2e52b89d391c2a2d7e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a276c5b77a040710e2a88a0bb15a94b9b6c6cd816eeed1076197bcfaf2920db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc18d21466b88d33db28308844a637d167ae3ce01be7a4831ec30ff36b407acd"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xleak --version")

    resource "testfile" do
      url "https://ghfast.top/https://github.com/chenrui333/github-action-test/releases/download/2025.11.16/test.xlsx"
      sha256 "1231165a2dcf688ba902579f0aafc63fc1481886c2ec7c2aa0b537d9cfd30676"
    end

    testpath.install resource("testfile")
    output = shell_output("#{bin}/xleak #{testpath}/test.xlsx")
    assert_match "Total: 5 rows × 2 columns", output
  end
end