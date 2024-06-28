class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https:docs.astral.shruff"
  url "https:github.comastral-shruffarchiverefstags0.5.0.tar.gz"
  sha256 "d82f44f45fc310345cb7d4ce3fc5c9a39556515062002804bb4ae9f6e191c2b2"
  license "MIT"
  head "https:github.comastral-shruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9df5ebde60a458bafb437674b8cee8260243f64f6b7882b7074f27bdbd2cbbdc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf2b1a213ba61b9a99c2b9d5b9d4d0832ff5dbc83ab6bf051ccdf9eecc2aedd6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ef350d59cb9936b53eeab5ae533cb48551414bb5d165b321458fee057c5eb4d"
    sha256 cellar: :any_skip_relocation, sonoma:         "cf5748e0884dc86aeb4e4f0d9287f3059a959c824c4c99f9af7cc3c918b51cd0"
    sha256 cellar: :any_skip_relocation, ventura:        "c06b3af06950814526a1deca07f05f4235e4d4fea4ff8218f04803c2aca68901"
    sha256 cellar: :any_skip_relocation, monterey:       "759e8d12f89e1191fbd18bcfd149e34606063f1f68e6dd227a354acef8e18a27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83091f5db5725e48eaadc3731798d67848f3035d92cee56db1eb78f51d9a0f9b"
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

    assert_match "`os` imported but unused", shell_output("#{bin}ruff check #{testpath}test.py", 1)
  end
end