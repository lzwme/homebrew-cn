class Sttr < Formula
  desc "CLI to perform various operations on string"
  homepage "https://github.com/abhimanyu003/sttr"
  url "https://ghfast.top/https://github.com/abhimanyu003/sttr/archive/refs/tags/v0.2.26.tar.gz"
  sha256 "d59a4f25c2ad4478699585aff16d3b99b9b1fddfb894bdf072705d6342aee59a"
  license "MIT"
  head "https://github.com/abhimanyu003/sttr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c5f46278b4ba6a72af5f05ca3edbee04324ba531928a0091b96f1e1db6008b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c5f46278b4ba6a72af5f05ca3edbee04324ba531928a0091b96f1e1db6008b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5c5f46278b4ba6a72af5f05ca3edbee04324ba531928a0091b96f1e1db6008b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "c72eaa56ef8829347dcf133ae8b0fde5454343459654464e690249b2ba3bc610"
    sha256 cellar: :any_skip_relocation, ventura:       "c72eaa56ef8829347dcf133ae8b0fde5454343459654464e690249b2ba3bc610"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4af644def0c89973296cf525a709ab820bc3dc0cf8fb28fff8a9ffbe5b3b70d9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sttr version")

    assert_equal "foobar", shell_output("#{bin}/sttr reverse raboof")

    output = shell_output("#{bin}/sttr sha1 foobar")
    assert_equal "8843d7f92416211de9ebb963ff4ce28125932878", output

    assert_equal "good_test", shell_output("#{bin}/sttr snake 'good test'")
  end
end