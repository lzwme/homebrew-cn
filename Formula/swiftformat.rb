class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://ghproxy.com/https://github.com/nicklockwood/SwiftFormat/archive/0.51.15.tar.gz"
  sha256 "94c4826b8bf9f4d16775c17def2c8c5741357ef22cbe10ee6f98261e337f6450"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "28b066efff4153430adaf82be56d60cb0e3dbc0a77c8777f13b68371a0e459cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5d7bad79f48ccd9a465e79720b63651ba4c46c0bc78053019c74b0ccd4ae506"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c12c1f519e4e73e430018c80e10385468baf2486d8657e623d6fe7112676bcfa"
    sha256 cellar: :any_skip_relocation, ventura:        "c1ee75071b5907feef95580d351acb1debe5981c115027812b3c3c918b06e1c6"
    sha256 cellar: :any_skip_relocation, monterey:       "ff2457fd5e9b7b1aa431546f5e2665ce74d1fa26526d930f1b041283de387728"
    sha256 cellar: :any_skip_relocation, big_sur:        "968da87e3561d3a69120778cec7b2c2a81266556053e13ff8e7853826e5c3bc6"
    sha256                               x86_64_linux:   "f9d220401d9530229cd24d8532525c218e5bd6085652fb6d6bb0fec80379dd01"
  end

  depends_on xcode: ["10.1", :build]

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/swiftformat"
  end

  test do
    (testpath/"potato.swift").write <<~EOS
      struct Potato {
        let baked: Bool
      }
    EOS
    system "#{bin}/swiftformat", "#{testpath}/potato.swift"
  end
end