class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://ghfast.top/https://github.com/sinelaw/fresh/archive/refs/tags/v0.1.93.tar.gz"
  sha256 "8217c78d002b7bfee2ca25e8532217a837a1966becc135f4d7cc1f83cfb163d7"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0c172691ef25ae826df9ad57c1b6275ce02ce5749f28c719786d9d6fdefa35b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77d61ac3377d119a53f46970837d454f0b71015dc7445d8b55d0e66d41d2ebbb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d5d801f9b34e92395a73e29bcbb847dbbec9744d5606bb25d39d74d9b6f8cef"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d56092837a6d26aed6a65f73a3d9964e91f0459eab91f4358f1d4fbb47f44e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9cf0fec5e989d68bda2109603d2c31fda89613b5a820a68514be4b9a6256226e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15ce360496a3d086532e00eb2097243707e41e039906e0236d78325547c421bc"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang to build rquickjs-sys

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/fresh-editor")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fresh --version")
    assert_equal "high-contrast", JSON.parse(shell_output("#{bin}/fresh --dump-config"))["theme"]
  end
end