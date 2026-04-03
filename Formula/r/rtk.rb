class Rtk < Formula
  desc "CLI proxy to minimize LLM token consumption"
  homepage "https://www.rtk-ai.app/"
  url "https://ghfast.top/https://github.com/rtk-ai/rtk/archive/refs/tags/v0.34.3.tar.gz"
  sha256 "c06bd083ad956a96ab16669518e1631880c86f24cce524dbefe51450f9f5557e"
  license "Apache-2.0"
  head "https://github.com/rtk-ai/rtk.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "417d5c1b96346a78aa8ef5747cc9011af6e314194381ea7bb85feb4a428007a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f15e2329c298cbfa0444dbb763ebf35afae87afa6cc38cf534cfe26f49257d85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d70339b4d2877141674709819cd7c068e7214a108bee6559b9670870c876025"
    sha256 cellar: :any_skip_relocation, sonoma:        "b10fe2ccb6d6705af478c5ab88fd7ab5378fe0d288f96ec357c9e06a4b155228"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c18bcb0d1bb056ef43cfa7109628bb8d9f913a856cb977f17ea2116c95274da1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a11daf79694e7c5663f2fe481fba2c902bdec97e3e0620d943c0a81169f34d8"
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