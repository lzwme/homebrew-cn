class Swiftdraw < Formula
  desc "Convert SVG into PDF, PNG, JPEG or SF Symbol"
  homepage "https://github.com/swhitty/SwiftDraw"
  url "https://ghfast.top/https://github.com/swhitty/SwiftDraw/archive/refs/tags/0.23.1.tar.gz"
  sha256 "7e5320397a83e8f21761834b8d7667660afaa65d6782bff88dee6d6e56f0d54e"
  license "Zlib"
  head "https://github.com/swhitty/SwiftDraw.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce2245d8509b955f637c14d77732c7c1aa68ca8168ac8d6c25aafd3e73b5f049"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5689b2c887b8c8f55c5902fc9090c9ddb77c23a3ac718ae3ba15cddd5f6cb677"
    sha256 cellar: :any_skip_relocation, sonoma:        "b169641f36a09cd0ffa943f8cf0d7dd9cdaebf2ec4f2f0536830c817e6338dc7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09db9b587a4c9257ac60352e95ae355e2e3036bf861446fa6f2455ccf45e3c1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "432fd1ebbb55cf47ae497b02519a223cf54eec881be993879b65114068aecf79"
  end

  depends_on xcode: ["16.0", :build]

  uses_from_macos "swift" => :build
  uses_from_macos "libxml2"

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "--configuration", "release"
    bin.install ".build/release/swiftdrawcli" => "swiftdraw"
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