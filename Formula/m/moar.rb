class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https:github.comwallesmoar"
  url "https:github.comwallesmoararchiverefstagsv1.31.1.tar.gz"
  sha256 "2d699c8322788943b77165e3a246ac493dad6233d9855ac84194923dfdbb40f1"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77e40a3a6ce626dfde3d3ae9d9d71f63aa180c2aa0c26ca621231653f4745007"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77e40a3a6ce626dfde3d3ae9d9d71f63aa180c2aa0c26ca621231653f4745007"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "77e40a3a6ce626dfde3d3ae9d9d71f63aa180c2aa0c26ca621231653f4745007"
    sha256 cellar: :any_skip_relocation, sonoma:        "e36c9d2dce0302141b39121e0f882a4ea5f4e9b8c90a3f473fbe08b4b4b759c0"
    sha256 cellar: :any_skip_relocation, ventura:       "e36c9d2dce0302141b39121e0f882a4ea5f4e9b8c90a3f473fbe08b4b4b759c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d28e37f49d9bd691805b0c033f726eb3fe8d02cf6719e93607882b79f48cfa3"
  end

  depends_on "go" => :build

  conflicts_with "moarvm", "rakudo-star", because: "both install `moar` binaries"

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
    man1.install "moar.1"
  end

  test do
    # Test piping text through moar
    (testpath"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}moar test.txt").strip
  end
end