class Diskwatch < Formula
  desc "Cross-platform disk diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/diskwatch"
  url "https://ghfast.top/https://github.com/matthart1983/diskwatch/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "eab82fede0cdc41787173a1bd5b533c48ff294e31abf451d1886b6b99e7e70e7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e12a237d0996d499e66c1c2ed44c902405e63670e7c6945dbf76e09007c4e3d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "554a344e5118dadc92556c86304df297b7a76809f6867f0a8186ba143af2f22d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "972dcda4c424933b65cd2cc135c6959f513f3a0c013d63a59643cc72c852e80d"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2be25d62465887ef7b302b4513c1f0d6fef6659d659ad49c36946f990b77b09"
    sha256 cellar: :any,                 arm64_linux:   "9bf491086a8ab8bb38c4014b78677f41f2736cced16d3c623d83d760a94a8477"
    sha256 cellar: :any,                 x86_64_linux:  "8690ca050b08d524b508e792f5d48c639444d08be14ee203e3b2e5d9659de93d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Devices", shell_output("#{bin}/diskwatch --diag")
  end
end