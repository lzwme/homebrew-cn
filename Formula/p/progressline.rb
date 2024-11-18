class Progressline < Formula
  desc "Track commands progress in a compact one-line format"
  homepage "https:github.comkattoufProgressLine"
  url "https:github.comkattoufProgressLinearchiverefstags0.2.3.tar.gz"
  sha256 "8d4362dc41ba73ccfccd66f5860b512695012e36eae031f84f57e14f67c1bf52"
  license "MIT"
  head "https:github.comkattoufProgressLine.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74d053a1ddd141c375735a7febbe6a9000b851502828279e250dea502c5a7b04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e967f8b2b1d9faaebcbf50f60a37b356346a6313a022d5ac8715d98f1a4a8b77"
    sha256 cellar: :any_skip_relocation, sonoma:        "54ebdeb72317c7f0c4d32a80f459e984bf01c3b1595e77e291e032b811ef80a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85bd239897d6f24d55de737a63bf686ad345f39c5f87250272077d699d6299f4"
  end

  # requires Swift 5.10
  depends_on xcode: ["15.3", :build]

  uses_from_macos "swift" => :build

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