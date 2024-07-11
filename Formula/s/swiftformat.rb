class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https:github.comnicklockwoodSwiftFormat"
  url "https:github.comnicklockwoodSwiftFormatarchiverefstags0.54.1.tar.gz"
  sha256 "82286ff52142b490b327a9709af447bab75a633cabe4421d209ddc004672506a"
  license "MIT"
  head "https:github.comnicklockwoodSwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e94f1f7592ef3f64c48246c9c72b4bc50e7cb585d6df92cc08ce764e107e3479"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c895cd456c368a38ad2b0880cb920d818b0cc7bd1ee61022cb69f3ebfce25132"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ca41fb78e1a097d713216e4456c0b3a2371e99b87c7051b08274b0dbb000dc4"
    sha256 cellar: :any_skip_relocation, sonoma:         "391bbbe8506d126b51dc7cde3a36ca0b06c6a26b84d8c9d9a753e9c57d03f7c4"
    sha256 cellar: :any_skip_relocation, ventura:        "ba24049a6318aa1121c2b0582b47c3a35f9e0a350774e5f731c1a22430d61d76"
    sha256 cellar: :any_skip_relocation, monterey:       "0154732e4de16113c1d938c9f36ce08708dc64935d78f6bed3c7a0ce53476697"
    sha256                               x86_64_linux:   "723ab8ec413507c1599d37cfbf839e12eeb922f633522aaf9f8f86b69bfb7e6c"
  end

  depends_on xcode: ["10.1", :build]

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".buildreleaseswiftformat"
  end

  test do
    (testpath"potato.swift").write <<~EOS
      struct Potato {
        let baked: Bool
      }
    EOS
    system "#{bin}swiftformat", "#{testpath}potato.swift"
  end
end