class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://mongodb.github.io/kingfisher/"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "8a68c0d5ea26f9437ce44a9bda21597a14a438709626e6190978aab8f6e0a2bd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2979881d4bd6563bef5ea2819990eb673aecc55b5b6c9a8fa45ab779c976ccfd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bf3a3e5f854964fe76f1208106feec610cb077ad52647d14aec25a7b6b9736b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "89b2fb419b1a2bc60629a927632a909e77e122c53f050011c03dc61ed6dbb866"
    sha256 cellar: :any,                 arm64_linux:       "54a85016bc257023f3a0973de7121e23d0c086122cac5e6950a7a2989033de90"
    sha256 cellar: :any,                 x86_64_linux:      "87a7fa0308e7a52081f71335d1aea3528d44e28543c2abab59b99bbf0d838032"
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