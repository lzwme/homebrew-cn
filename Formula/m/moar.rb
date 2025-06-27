class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https:github.comwallesmoar"
  url "https:github.comwallesmoararchiverefstagsv1.32.1.tar.gz"
  sha256 "e1e68d0065dbc20275bb84d212feba10d236e55a103f2e9cf5fc233565a877e6"
  license "BSD-2-Clause"
  head "https:github.comwallesmoar.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20c69cac1d5cbfee5b5f3e9846ea85a2298bb42d1c7b3ca2355cbeb119716cf8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20c69cac1d5cbfee5b5f3e9846ea85a2298bb42d1c7b3ca2355cbeb119716cf8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "20c69cac1d5cbfee5b5f3e9846ea85a2298bb42d1c7b3ca2355cbeb119716cf8"
    sha256 cellar: :any_skip_relocation, sonoma:        "29782ca2eb04be68ee02a5c3ec7cba729e80cf92235cce1e4fbe1d4b79bb4f60"
    sha256 cellar: :any_skip_relocation, ventura:       "29782ca2eb04be68ee02a5c3ec7cba729e80cf92235cce1e4fbe1d4b79bb4f60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b029a7c272c491fa5223211a2163266aeea98cf3899449aa7eed51b44b57621"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f67229e596f3319fd9aaaefdb46f121c8fb82abac410a0aa82a475b250bace6"
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