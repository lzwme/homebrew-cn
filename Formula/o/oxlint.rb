class Oxlint < Formula
  desc "High-performance linter for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://ghfast.top/https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.51.0.tar.gz"
  sha256 "30e9ea6f9344d8e3d16059414ee69e91bb1c7597b5566d5ad3e2e63ae2874078"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint_v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb6eacdb3f9af010a0d8a9eec0edea7956ee4642e5f6889c7ddb32bac4699640"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79db333b03fbd308d637da67208d1621e631b271ae5453990c5426b1b0f0a86c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab0056a9402278567dd828f74c89f86dfe813fed9fb667779b60adb013c90b6d"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9715dcaed7a8fee1fc755f8f08ed495f0d05f03657350cb0627588f627e6ad9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e40ddf87ea766f91e57036c034e04f203560549a307f544a926f023611dc83f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b9e33425383f0a2346e4654b20dedbd0c0a94eea769e62991f1716632511e3a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "apps/oxlint")
  end

  test do
    (testpath/"test.js").write "const x = 1;"
    output = shell_output("#{bin}/oxlint test.js 2>&1")
    assert_match "eslint(no-unused-vars): Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}/oxlint --version")
  end
end