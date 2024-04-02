class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https:docs.astral.shruff"
  url "https:github.comastral-shruffarchiverefstagsv0.3.5.tar.gz"
  sha256 "44ec048e84335eaafb435c50edec83dbd1cd818fad4fe41d9c6e12a9837f0484"
  license "MIT"
  head "https:github.comastral-shruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bd3ed932fe4ef435b58c0889848faea9880229f9f3ffd6fa3131de5f08602df3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c71a9817e6b244173e8d125a7dde615dc9cf5796df81c5a65259b2d1c3d1ba37"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9595691dd6dd4f6abb9fd57edd620ff7c26d03e87ada0a2186476b0d2a08cc7"
    sha256 cellar: :any_skip_relocation, sonoma:         "79452afe9262610a48bc58316cf1f84eb4af1486752b0ff4c2722427fc21cb24"
    sha256 cellar: :any_skip_relocation, ventura:        "0403ee6619a54d221a44399c6532acd0fcc1957722e819f47d838972cb631350"
    sha256 cellar: :any_skip_relocation, monterey:       "d0b5dec6541a3c7b0a0c99ec7ed6a1578c3e81435cf42f1d927b2b50f9af1629"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1bf1d954f5bd08b653632d7c2b8bb45eeac477b764abafbd866b85cffbeadfd7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "cratesruff")
    generate_completions_from_executable(bin"ruff", "generate-shell-completion")
  end

  test do
    (testpath"test.py").write <<~EOS
      import os
    EOS

    assert_match "`os` imported but unused", shell_output("#{bin}ruff --quiet #{testpath}test.py", 1)
  end
end