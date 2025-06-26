class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https:github.comwallesmoar"
  url "https:github.comwallesmoararchiverefstagsv1.32.0.tar.gz"
  sha256 "72a9d62d62c84fb3a07f65fae27cdf9065d988d5f7d174f56f6eed7c74ec2247"
  license "BSD-2-Clause"
  head "https:github.comwallesmoar.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6851742561f910bce17adbf650e2d7b9fed2df2e6b771be758a1ea16ef70e399"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6851742561f910bce17adbf650e2d7b9fed2df2e6b771be758a1ea16ef70e399"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6851742561f910bce17adbf650e2d7b9fed2df2e6b771be758a1ea16ef70e399"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd7a9ecaa1b8daeb7df93e632600321bd267ea065c726a5f4ba521488440c6c4"
    sha256 cellar: :any_skip_relocation, ventura:       "cd7a9ecaa1b8daeb7df93e632600321bd267ea065c726a5f4ba521488440c6c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77a815ac335cd679fdab248c4cc11a51eb490d32dec6b2249ac688d79c06aea1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd97a16a7049165798c358eabd35fd916f7c9475fbebf606f73d495267e386ac"
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