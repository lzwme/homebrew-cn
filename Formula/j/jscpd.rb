class Jscpd < Formula
  desc "Copy/paste detector for programming source code"
  homepage "https://github.com/kucherenko/jscpd"
  url "https://ghfast.top/https://github.com/kucherenko/jscpd/archive/refs/tags/v5.0.6.tar.gz"
  sha256 "65c1d1124a896df2028c0aca2d7ba4b27daac7c6b32c0d51fdda92df60cdce2c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "567b7c46962058650fb8860c0a37f6910f9bbc7822f5bed666aee3f06ccd720b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07cf312aa47858c5be75d1df288eb8ba42d6d0eebef96aba72c89a0eab4079e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1c328c65527a608f2dc09a2619f4b57340a93995b26ddcaa58ffe48b0a5b45f"
    sha256 cellar: :any_skip_relocation, sonoma:        "480f44e6f637c7ac311b9c4dfe59c43192b27a357e0429b04fbfc7bc7642ece8"
    sha256 cellar: :any,                 arm64_linux:   "465b52c49fac32090f76d0df27dcd411209e7ea9a7d7bf2e6e1a3672f8e439c3"
    sha256 cellar: :any,                 x86_64_linux:  "102595fa7ca391bec6def94f2eb33b85fdbb23d5a2947c1968ae723bfe546146"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "rust/crates/cpd")
  end

  test do
    test_file = testpath/"test.js"
    test_file2 = testpath/"test2.js"
    test_file.write <<~JAVASCRIPT
      console.log("Hello, world!");
    JAVASCRIPT
    test_file2.write <<~JAVASCRIPT
      console.log("Hello, brewtest!");
    JAVASCRIPT

    output = shell_output("#{bin}/jscpd --min-lines 1 #{testpath}/*.js 2>&1")
    assert_match "Found 0 clones", output

    assert_match version.to_s, shell_output("#{bin}/jscpd --version")
  end
end