class Dskditto < Formula
  desc "Ultra-fast duplicate file finder TUI/GUI"
  homepage "https://github.com/jdefrancesco/dskDitto"
  url "https://ghfast.top/https://github.com/jdefrancesco/dskDitto/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "9cd4a3a3fae12ef85f0b76c0f42c7778995647cf6cc53f8f12369c74aba43b4f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "43b9a3a6af9afc9a8f5f58bf0ec275ba8a0817a916b6ee37ae93260e342f7947"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3930974b0722594b81ddcae9123e824b2dbfef1ecbf568710adc14bf6e07ad81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29d2e4e4b8f19abe90c554a92723adc0fc6efc391f3b3893ac7445edf6ae4287"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aaf1f512c57c3ae604a924da96333d30f5aba2879f2d0dc05f6110af7485ff42"
    sha256 cellar: :any,                 x86_64_linux:  "cbbdac950133b491e8a7af9a8e19fea81bd6c07bbcfe692790b89db45dc93cbf"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/jdefrancesco/dskDitto/internal/buildinfo.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/dskDitto"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dskditto --version")
    assert_match "GUI support was not built", shell_output("#{bin}/dskditto --gui #{testpath} 2>&1", 1)

    (testpath/"a.txt").write "This is a test"
    (testpath/"b.txt").write "This is another test"
    cp testpath/"a.txt", testpath/"c.txt"
    output = shell_output("#{bin}/dskditto --remove 1 #{testpath}")
    assert_match "Removed 1 duplicate", output
    assert_equal 1, [testpath/"a.txt", testpath/"c.txt"].count(&:exist?)
    assert_path_exists testpath/"b.txt"
  end
end