class PfetchRs < Formula
  desc "Pretty system information tool written in Rust"
  homepage "https://github.com/Gobidev/pfetch-rs"
  url "https://ghfast.top/https://github.com/Gobidev/pfetch-rs/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "4661b975f1a03716bef60a70fa48cfc8a469791da8119759a63306b2490c293b"
  license "MIT"
  head "https://github.com/Gobidev/pfetch-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "157ed8003d19ea0bb22192474f235ba4660ff53c5f52b804f82d6cf608c67430"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "810d4e8535aff8fb594bbb54f5ee7275e2bc5957bed520fb50d94392956bc5d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4131703f84a9ee7bca245df94a11f5ad2b780b325257fe6dcf44991d819bd741"
    sha256 cellar: :any,                 arm64_linux:       "9a38b1eebf826dd5b6325428d6b072f3af053b7feb2bf81bdfdd5326eb06a031"
    sha256 cellar: :any,                 x86_64_linux:      "fae007f5cc8bc10b8b7aec52c081774ab843d50dd38e00307c4a472b6ae2a74e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "uptime", shell_output("#{bin}/pfetch")
  end
end