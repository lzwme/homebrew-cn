class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https:github.comwallesmoar"
  url "https:github.comwallesmoararchiverefstagsv1.27.0.tar.gz"
  sha256 "25ee9b0704803c4635c1619541b4a5b562eec45ed6b77a0c44bcabe5b542f0ed"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "4ebd5a64c9f3b157f3e37d94aeac862b8fc8b03f0565c446822d9eef6fa9533d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4ebd5a64c9f3b157f3e37d94aeac862b8fc8b03f0565c446822d9eef6fa9533d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ebd5a64c9f3b157f3e37d94aeac862b8fc8b03f0565c446822d9eef6fa9533d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ebd5a64c9f3b157f3e37d94aeac862b8fc8b03f0565c446822d9eef6fa9533d"
    sha256 cellar: :any_skip_relocation, sonoma:         "e5e71e9a02adfa4374fa8aa510ea25c54fe84f4b5e72e6c8145576f259aedc7e"
    sha256 cellar: :any_skip_relocation, ventura:        "e5e71e9a02adfa4374fa8aa510ea25c54fe84f4b5e72e6c8145576f259aedc7e"
    sha256 cellar: :any_skip_relocation, monterey:       "e5e71e9a02adfa4374fa8aa510ea25c54fe84f4b5e72e6c8145576f259aedc7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4eb55e6a373d0b9a11c5be25cfe69483804930db5458d1e7805439e25dabdda"
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