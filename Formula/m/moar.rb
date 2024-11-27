class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https:github.comwallesmoar"
  url "https:github.comwallesmoararchiverefstagsv1.30.0.tar.gz"
  sha256 "a26954fca06c95604a94b6f208f62eff247e50c8d239262322a13d0959074de1"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c459b0aae8386b7b331a44030747603165c00ba244f359eda279da264bf2705c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c459b0aae8386b7b331a44030747603165c00ba244f359eda279da264bf2705c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c459b0aae8386b7b331a44030747603165c00ba244f359eda279da264bf2705c"
    sha256 cellar: :any_skip_relocation, sonoma:        "a54c7ca178391beef65f7c07cb563c655077796aff0e39ae6923833725874cb6"
    sha256 cellar: :any_skip_relocation, ventura:       "a54c7ca178391beef65f7c07cb563c655077796aff0e39ae6923833725874cb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d480a9fcfbcd23e70432419b68e8f1712cd7b13f4694824cfdcb4ed3525c759d"
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