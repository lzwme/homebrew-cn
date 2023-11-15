class Swiftdraw < Formula
  desc "Convert SVG into PDF, PNG, JPEG or SF Symbol"
  homepage "https://github.com/swhitty/SwiftDraw"
  url "https://ghproxy.com/https://github.com/swhitty/SwiftDraw/archive/refs/tags/0.16.0.tar.gz"
  sha256 "bf8f3846bf5a4da9c97aa6942ce8ff4f6f657ff0cd269d8dedf5a3a802a09d43"
  license "Zlib"
  head "https://github.com/swhitty/SwiftDraw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "faec3730f5dadb3e192e7496d34c415a721e73a4ff94a33b1d4648c90ec5159a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "49c6b65ef8a6d0e8dc9f8bfad3019d6602836003fb2f62bd6d39cc272df2b4ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d313971c6a595ce6221251512273d881c9471af3ba8c795fa50682473e5f086"
    sha256 cellar: :any_skip_relocation, sonoma:         "d04f3c068c6593286a36d44bac6eee80169c9711d3012ce6b9f9b88eeb3a456d"
    sha256 cellar: :any_skip_relocation, ventura:        "a921c228ad7ad6324afb091a06ee14fb6a358ad780393935dc42faafd8272c2d"
    sha256 cellar: :any_skip_relocation, monterey:       "88efe077d6dd307c53e4ae15ab7c74635b886468750d8c5184e08734d3814015"
    sha256                               x86_64_linux:   "250129a210b5c79c79c7ab990a68050c03ee6b94fba8fdb77eeaec56fed14483"
  end

  depends_on xcode: ["12.5", :build]
  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/swiftdraw"
  end

  test do
    (testpath/"fish.svg").write <<~EOS
      <?xml version="1.0" encoding="utf-8"?>
      <svg version="1.1" xmlns="http://www.w3.org/2000/svg" width="160" height="160">
        <path d="m 80 20 a 50 50 0 1 0 50 50 h -50 z" fill="pink" stroke="black" stroke-width="2" transform="rotate(45, 80, 80)"/>
      </svg>
    EOS
    system bin/"swiftdraw", testpath/"fish.svg", "--format", "sfsymbol"
    assert_path_exists testpath/"fish-symbol.svg"
  end
end