class Progressline < Formula
  desc "Track commands progress in a compact one-line format"
  homepage "https:github.comkattoufProgressLine"
  url "https:github.comkattoufProgressLinearchiverefstags0.2.3.tar.gz"
  sha256 "8d4362dc41ba73ccfccd66f5860b512695012e36eae031f84f57e14f67c1bf52"
  license "MIT"
  head "https:github.comkattoufProgressLine.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a08aa0971dbb4645019cf6a0f0fbc4b872ec8064dfebbf5369e2cc3139cb308"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a7570ba3cdcdf239e8b169c7b658dd2c11edf95357e985b20e27d905752a5ea"
    sha256 cellar: :any,                 arm64_ventura: "9392899be38e0b052228ee8bb0bdbd9814c7c3ced4ff4c22137cb6020a3ca484"
    sha256 cellar: :any_skip_relocation, sonoma:        "f7c9b1c6026151cfb3df42ecc479b5ffd3079da8c733fa52e287215164b45049"
    sha256 cellar: :any,                 ventura:       "e9c144895d1dc13472c380865779d335dba4c685630ea5fa4d7c5eeb45126a46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6cd91a1e0e79936c1d9c40157022109ad4708dc95183a1f87f2927ec1262782"
  end

  uses_from_macos "swift" => :build, since: :sonoma # swift 5.10+

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "--configuration", "release"
    bin.install ".buildreleaseprogressline"
  end

  test do
    some_command_multiline_output = "First line\nSecond line\nLast line"
    assert_match "✓ 0s ❯ Last line", pipe_output(bin"progressline", some_command_multiline_output).chomp
  end
end