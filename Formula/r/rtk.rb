class Rtk < Formula
  desc "CLI proxy to minimize LLM token consumption"
  homepage "https://www.rtk-ai.app/"
  url "https://ghfast.top/https://github.com/rtk-ai/rtk/archive/refs/tags/v0.44.2.tar.gz"
  sha256 "39061f634a607c9642af0430cda1b20e55cd61bf53f08cfc9b3f27862ec719f2"
  license "Apache-2.0"
  head "https://github.com/rtk-ai/rtk.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "632d3d85f72c4be58eab513e81d20c2bc2fd767753d961ae4672479a340adc9a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e08aa1bdf648eda48353d13223db39dd680a1daebd5a2b26f1c050e7475f006d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c955a65feed62abb853270ed43bb0138ecd7f4e58651a65c758f1853a23d793"
    sha256 cellar: :any_skip_relocation, sonoma:        "062b42dee49a4621777abed607a2a1b30c90937a2b2330d4470bf963446d407a"
    sha256 cellar: :any,                 arm64_linux:   "53bce4f2a15a7a6c983e3a5cd69fea6ed020849c92b7837cc5e75b20ff17ea7e"
    sha256 cellar: :any,                 x86_64_linux:  "bb929bdfd69d19d9915d196c488f4b9e6750b9d2dbcd64d4b4049baabcaaf803"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rtk --version")

    (testpath/"homebrew.txt").write "hello from homebrew\n"
    output = shell_output("#{bin}/rtk ls #{testpath}")
    assert_match "homebrew.txt", output
  end
end