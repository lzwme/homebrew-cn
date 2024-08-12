class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https:github.comwallesmoar"
  url "https:github.comwallesmoararchiverefstagsv1.25.4.tar.gz"
  sha256 "908395f560d2dc60b1b29c0fc1ed3b0f43ab6cc527ff3ae645f4e8e4c44f6ecf"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c0469135be8474f2ba0c78d1ad935dfd814240edad100d36b0aee51374ced7a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0469135be8474f2ba0c78d1ad935dfd814240edad100d36b0aee51374ced7a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0469135be8474f2ba0c78d1ad935dfd814240edad100d36b0aee51374ced7a9"
    sha256 cellar: :any_skip_relocation, sonoma:         "a12dbe4396d26e0b4ef67a5819c84a9aa960f437be8a6a2f426de0ca8b94a1ee"
    sha256 cellar: :any_skip_relocation, ventura:        "a12dbe4396d26e0b4ef67a5819c84a9aa960f437be8a6a2f426de0ca8b94a1ee"
    sha256 cellar: :any_skip_relocation, monterey:       "a12dbe4396d26e0b4ef67a5819c84a9aa960f437be8a6a2f426de0ca8b94a1ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41617afc08be82776bc8a3b2db09a23f50b8132d48d604e578df8a85bc201d8b"
  end

  depends_on "go" => :build

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