class CargoInstruments < Formula
  desc "Easily generate Instruments traces for your rust crate"
  homepage "https:github.comcmyrcargo-instruments"
  url "https:github.comcmyrcargo-instrumentsarchiverefstagsv0.4.11.tar.gz"
  sha256 "170604bf216814b8557eb60aef8d2f586373d8fbe6dacefcd2319e5289c202e8"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "62fa7839a37588f824c00b54835855db0fca84898765cf55df91aac9a823c754"
    sha256 cellar: :any, arm64_sonoma:  "e948eb2795d82441f25e3b6e127a8400e7c32338eeb392e779454edf0c7b5a11"
    sha256 cellar: :any, arm64_ventura: "c896e3e4e8cab385c7adc9462a2ce49ea0aecba1b6ce4a99ed73e3a339ba45f4"
    sha256 cellar: :any, sonoma:        "5d5222a25f7bbc73c3f613f1338c7ce04c732f9c45e6da07bacf2da3dea92fc9"
    sha256 cellar: :any, ventura:       "a2487292ce190bb131b9b0b904a0ee09b79fb7624d9cc33358b46193465b2d6d"
  end

  depends_on "rust" => :build
  depends_on :macos
  depends_on "openssl@3"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output "#{bin}cargo-instruments instruments", 1
    assert_match output, "could not find `Cargo.toml` in `#{Dir.pwd}` or any parent directory"
  end
end