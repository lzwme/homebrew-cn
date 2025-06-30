class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https:github.comwallesmoar"
  url "https:github.comwallesmoararchiverefstagsv1.32.2.tar.gz"
  sha256 "50f485235ff1d7d3dc8fdb3042624dbb1ccdedc0e6bc825cdcd9aed045352801"
  license "BSD-2-Clause"
  head "https:github.comwallesmoar.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d585dddba44d1b6c1712f9d14292539bc40887e40c58a6797e596494afe010e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d585dddba44d1b6c1712f9d14292539bc40887e40c58a6797e596494afe010e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1d585dddba44d1b6c1712f9d14292539bc40887e40c58a6797e596494afe010e"
    sha256 cellar: :any_skip_relocation, sonoma:        "3bc997e618aae1141b67ede66835f49a5643871d1b810f83510e1ba329ca097f"
    sha256 cellar: :any_skip_relocation, ventura:       "3bc997e618aae1141b67ede66835f49a5643871d1b810f83510e1ba329ca097f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1196d96a7fd5c7c5a6058962243822878b909060b78ab83cbe44a8129b42e08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ddacdc8dcb0ff42f8563676c99b5dfe77156ce74dc12986a71acdf030b0babb"
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