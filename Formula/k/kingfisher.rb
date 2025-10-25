class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.60.0.tar.gz"
  sha256 "f115febe29d838bf021740a240a60c58f7d24ef88cf453477d3fd35bcd160304"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1938f41beb2c2dc4581192eb0f0ed4d96183237085707688e9e4ff133c78e02b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e1227a2acda5f5a54ac95f6122175227303bf2e8ce73c535a687dff1892b046"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3e9d34dd2d1558e69cf6051aff6bfdc535785470a5d234ad21d45ffd0d75232"
    sha256 cellar: :any_skip_relocation, sonoma:        "94b44a7c481e7f4df83e892ed3f792350029d1e2674ad64c40d52ca5741a109a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f1bc0cde0dcc881c016f6b678cd701c6b3478fa2572f548f0249cdadaaf5373"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07ccabe51192dbda68e582c2b0f13a4f9f8ec1454493b43dc4ee76a2d474812a"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  def install
    system "cargo", "install", "--features", "system-alloc", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end