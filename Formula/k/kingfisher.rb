class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://mongodb.github.io/kingfisher/"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "f5d5015bd5d0a8596331bc8187289d895e6505affb09b5e1384449e34f44bf5f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "99d8f4538ef9804ab16960c3f902b498a32546f9baed7d2e7d85e76958cdd889"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2aa824573e08304e3f6bc991596f05084cfb2c2a001bb204c6c3c53a8d64f8f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "188d16dca6ed839cd835089ecc62adb4f4eca5b9127898e53b7d21409274c097"
    sha256 cellar: :any,                 arm64_linux:       "0958a0b8f5e5120d40479917f36cea37e34fdb8f9f901383b65845c66109c4b5"
    sha256 cellar: :any,                 x86_64_linux:      "68bec9b0629b930f7501a922be9566e60f8d562ca9889aa5c3c5888341f8e823"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "openssl@3" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  def install
    args = std_cargo_args
    args << "--features=system-alloc" if OS.mac?
    system "cargo", "install", *args
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end