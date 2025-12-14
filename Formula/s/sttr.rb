class Sttr < Formula
  desc "CLI to perform various operations on string"
  homepage "https://github.com/abhimanyu003/sttr"
  url "https://ghfast.top/https://github.com/abhimanyu003/sttr/archive/refs/tags/v0.2.29.tar.gz"
  sha256 "ee9031656861671fd6103fb8d74cede331d92c39afd13b95d0b323debf26bf84"
  license "MIT"
  head "https://github.com/abhimanyu003/sttr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "11f22e971807d1479387b9aaad99274f9fd945629635a2dc0153f0124b3ff010"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11f22e971807d1479387b9aaad99274f9fd945629635a2dc0153f0124b3ff010"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11f22e971807d1479387b9aaad99274f9fd945629635a2dc0153f0124b3ff010"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8e2d90c1a2e8fe824954508204ec1c3c8916b16b3e2e47f92b724879cd6cf76"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b028aabce96b1d930e95ee98da1df222125f8f8200984dc8503952763dff80f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a8bba635557e10d22ed13f5466ea578698114ed18af115c9029d29fa30ba804"
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