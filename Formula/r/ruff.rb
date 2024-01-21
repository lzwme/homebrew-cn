class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https:docs.astral.shruff"
  url "https:github.comastral-shruffarchiverefstagsv0.1.14.tar.gz"
  sha256 "7b186090cab2dfd602dc36f8abfb68b8421fb1e959fbc023e001eed2e5ea8cdd"
  license "MIT"
  head "https:github.comastral-shruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c67cbfc331f7432a876222dc79616b6116e53e3adcfaa45771f90cfab5b6ead4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "38893fcfc1f0a59f75d08ee135d0fc4a04e9b7cd65a7bfa46061b848d717b732"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7556d89f9bd36b501e3086adef2817d8fb555dc63ddede609a2593340fc1fddb"
    sha256 cellar: :any_skip_relocation, sonoma:         "347e0d13a437c9d1a8f8652a2fa124a3b15c5be00a1777149e5d93cf4cbc4497"
    sha256 cellar: :any_skip_relocation, ventura:        "e4659cc75e8e8e15c25b92725763d1ede50355a7c34ae1cc2d9704f847b07807"
    sha256 cellar: :any_skip_relocation, monterey:       "b656a522c2f55f8e75b6a7877116d472d3917d246e7f5edee9e018e9dbb9fb74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "048346f5ebe653d0ece9f201bdabcf3b94bd4c50b5acd18d06621adc99176e7f"
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