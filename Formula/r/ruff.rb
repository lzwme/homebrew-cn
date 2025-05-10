class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https:docs.astral.shruff"
  url "https:github.comastral-shruffarchiverefstags0.11.9.tar.gz"
  sha256 "7813b1c4950597dbcd128072bb84ba1efe2440418f867000bff5fcae0ba53ceb"
  license "MIT"
  head "https:github.comastral-shruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d669f38fcc4d6565cb1bd150b8c09b9005cea8fc6327c30b8633cc2f763a446"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aadc5b8f112f4a2cc887c2af02f56b184d919566d3b92aecd31dfeae59269528"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9d99a63da5572f820278d978e61b4d00afeeab195cf222beded6f586ad197918"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a8994f708123891ae540e57b8b817771697adfa819057888b8482f21318e2dd"
    sha256 cellar: :any_skip_relocation, ventura:       "b93be442e0eae6d4cc1ed0991c244e3cfd196a7bef0c28da643ba6afff8b1487"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1283b7e2af96e8d02578dc8d85080d545d5e1fb1c05197795ed256c9f1c888db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50aebc2c5aa751cfb979db10cd04c83e9afcb4fb0402711d24d8cd85fa9c4f98"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "cratesruff")
    generate_completions_from_executable(bin"ruff", "generate-shell-completion")
  end

  test do
    (testpath"test.py").write <<~PYTHON
      import os
    PYTHON

    assert_match "`os` imported but unused", shell_output("#{bin}ruff check #{testpath}test.py", 1)
  end
end