class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://ghfast.top/https://github.com/crate-ci/typos/archive/refs/tags/v1.47.0.tar.gz"
  sha256 "dc538f582f90aec6ccd92635667aa782de0339b7c33f25512f60b2512afdd181"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b1c3a09fa22e9a9ddb53ab48ef7e97fce37a95684050a04aaf1b34896e38fa5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b12a8c7ba9194e61287951cd8b76887f11ff7da71ce580e63dba47058218c7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd931b179c37bcccee22e0571ac247777a27d8237785ffff51f5e5e762147735"
    sha256 cellar: :any_skip_relocation, sonoma:        "4fc635ec797b7e67adb90fc5a6eb7c78158c893a361b10b18732a024a60fbc6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7dca1d0f00447f7bf7388693370a938ac735c608cc00f72f898af18a8ee103b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47a8c6960d2144a1725506f83a373c64d8b8129b0f96a4ae844c7df85048ec43"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/typos-cli")
  end

  test do
    assert_match "error: `teh` should be `the`", pipe_output("#{bin}/typos -", "teh", 2)
    assert_empty pipe_output("#{bin}/typos -", "the")
  end
end