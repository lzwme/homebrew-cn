class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.92.0.tar.gz"
  sha256 "14d82c5976a83bf93ec2caf2a06c1e7b33fe024bd6c58b1f4b458dc21ba01a08"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a3cdffe6d6641808e8a34a3a8a9688e4caa85864530ba040a295c37cb2bbc270"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fbe359e0bae55d21a04b6a05e3b26e17f9db654fd43d44772b83a8b3490ad500"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26beeb139bf38c14a3fb88aa7d473c1615dc2c43eb59a8050c10192be9c03329"
    sha256 cellar: :any_skip_relocation, sonoma:        "aeada68c6dda58391ebeef1625f150906949cb34b539519d0e8a4a5342d83fbc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56c3a16ed16b4ca776a41f8a8fe220b19a2e6f9bc806860b1505a54b168aff07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa471f256dc0fff239c98e2e468635a90c56c47365f0dae5dfba5c32eeb4620e"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  def install
    system "cargo", "install", *std_cargo_args(features: "system-alloc")
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end