class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https:github.comwallesmoar"
  url "https:github.comwallesmoararchiverefstagsv1.29.0.tar.gz"
  sha256 "a3e91b021e8b5d8546c1b0b31a0750396c05488ea2eafd57c2e1b312daa62d91"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9247afc8f66105870a7ac15a1fea8031d2410dffe728ca8f476b44e8f0e2a2ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9247afc8f66105870a7ac15a1fea8031d2410dffe728ca8f476b44e8f0e2a2ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9247afc8f66105870a7ac15a1fea8031d2410dffe728ca8f476b44e8f0e2a2ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6ed8b113808002593896af54145d6067a4466ffbfde3ec880e255fc78c65995"
    sha256 cellar: :any_skip_relocation, ventura:       "a6ed8b113808002593896af54145d6067a4466ffbfde3ec880e255fc78c65995"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5b533bbfe06de87f9ce27394cabde7a1f73259465ba753cd496ae749452ea46"
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