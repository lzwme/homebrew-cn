class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://ghproxy.com/https://github.com/astral-sh/ruff/archive/refs/tags/v0.1.7.tar.gz"
  sha256 "e229d6004c29d96063eb55ef80fa8eaffbf89389829d19206b7853f763361fca"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "790ebcbb362c85654f56926554b0567f1e461c5a290a6dfa9ee7eb6cb1f0f29f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b022612571cb418b8fb8539a8a93c7e55e17430dd24d56d90744b5293efa4621"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "948a9d2f9eff9ce7a68f1e84dd66827135feb9f0bc5f34b578c3cd8366b02937"
    sha256 cellar: :any_skip_relocation, sonoma:         "191d2a36f2ac668e137be8749df88a8d504c57422cff24b0f54afde3fe5c788d"
    sha256 cellar: :any_skip_relocation, ventura:        "aac1d3ef6dfd23ec8fceba9f1851e8d46116d8806c1ec9538632454accbf4e58"
    sha256 cellar: :any_skip_relocation, monterey:       "e1830b14d679f2cb70531c41047f6f7835d695b6155fe5c9c5fade570595e97d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab121b0cbdfb883c05a08133969a72cab48ff25de83e92cad8111b968e2cf7fb"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/ruff_cli")
    generate_completions_from_executable(bin/"ruff", "generate-shell-completion")
  end

  test do
    (testpath/"test.py").write <<~EOS
      import os
    EOS

    assert_match "`os` imported but unused", shell_output("#{bin}/ruff --quiet #{testpath}/test.py", 1)
  end
end