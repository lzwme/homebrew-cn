class Models < Formula
  desc "Fast TUI and CLI for browsing AI models, benchmarks, and coding agents"
  homepage "https://reyamira.github.io/models/"
  url "https://ghfast.top/https://github.com/reyamira/models/archive/refs/tags/v0.12.2.tar.gz"
  sha256 "a01eae4263618a0a5e539ac3e17702a9becaa50ce293c5efd3f26abcc923850f"
  license "MIT"
  head "https://github.com/reyamira/models.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb69ea53a814bb52b509efdc1690177cf6cfa238e56594d66217aaf85e31e526"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "391438551bcf0395785d86729884b21616c221d4c5478c40b54c3fb0d6fe92c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86ff3df6a1e436dda1f374cf649585454b1d24e193ba0912ac50db62af1ec263"
    sha256 cellar: :any_skip_relocation, sonoma:        "cef6d47778b9f4f2f6064f1c3eec64708eced6ad812eba550a5de0fbd14e3753"
    sha256 cellar: :any,                 arm64_linux:   "3ceadd17489c816de1f05f18904cafa0a264249e1b15854e02974223575a77fd"
    sha256 cellar: :any,                 x86_64_linux:  "02eab34be7fb3da768033ca2972f380d34aafdee55eac2a1d42b271c834a9413"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/models --version")
    assert_match "claude-code", shell_output("#{bin}/models agents list-sources")
  end
end