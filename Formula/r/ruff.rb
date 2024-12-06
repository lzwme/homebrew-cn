class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https:docs.astral.shruff"
  url "https:github.comastral-shruffarchiverefstags0.8.2.tar.gz"
  sha256 "46ae2a51c96783a2a9afef1b63639f78e043431793206d1db1406fa5e85db903"
  license "MIT"
  head "https:github.comastral-shruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9593174e89ea299a738f12921617436b27b70136099142cce5bb12cc944597d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a4be347a6511ece359f503caf224f4a183a7cb2021a5a9c19bae1285377624b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7d9c83b2eec5bd9502f9ac2c392c9dbf12bb6fa31fec1f55ea8dc7583e598aa5"
    sha256 cellar: :any_skip_relocation, sonoma:        "03e335e98b8def8bc505018994366449f5d9df37210ca762fa136332153e8938"
    sha256 cellar: :any_skip_relocation, ventura:       "c4db26f4df56b42bc74555813317fee7b559577cb0960d95547d351717913909"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a0821244260da4aea01bf8671dc5fa22842646a7f04a160182e00a7300da5f3"
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