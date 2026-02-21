class Rtk < Formula
  desc "CLI proxy to minimize LLM token consumption"
  homepage "https://www.rtk-ai.app/"
  url "https://ghfast.top/https://github.com/rtk-ai/rtk/archive/refs/tags/v0.22.2.tar.gz"
  sha256 "cf8048e4c40f712e553b41078de52de4436902cfae92bea7d47f097ce24c1b5e"
  license "MIT"
  head "https://github.com/rtk-ai/rtk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc06ddb2be057210100a69a88a5dc530d5a787b9318240082d6ca6954c360333"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "daa1fc9720279e587531d31b6d2b55c28cbd795d1f3b47fbfe327c808c35c743"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55b509c3a687df47eb133e72c6a3965007bae7dea5896cdd9dac9d7eb026361f"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1815f31222bfda1d084e71b163f504f7ad66c47f6ff3fcc517c46a801a43038"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2602c4c4336609c6c3e4728580e6bde1ffacadbc153b865c16afa776d6a3bd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b23e384f06ab2fce4c2d4bc367cb73e8ccec01074d4024f8a96374c39af549f6"
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