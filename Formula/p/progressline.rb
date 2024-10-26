class Progressline < Formula
  desc "Track commands progress in a compact one-line format"
  homepage "https:github.comkattoufProgressLine"
  url "https:github.comkattoufProgressLinearchiverefstags0.2.2.tar.gz"
  sha256 "6c3ee9bdb633b2b616f3fe0c3f4535a1c307d8c031deae0d90bfdbb447061fed"
  license "MIT"
  revision 1
  head "https:github.comkattoufProgressLine.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72af65d2ff55c83a0b07242b96d654b2266d283565e8560b6a61db24c2d7b049"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77fd383d4735e67c038d61835770731f3c29a14a84394ecc024ed348c0c489ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "31888bebb2589c1f57820832416598bc111f087fcab2472f1ece4391770fa110"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68f5ef0254d75f14499282d1a229d1cdc6015c4471cbeba507dd72443270a1f7"
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