class Mactop < Formula
  desc "Apple Silicon Monitor Top written in Golang"
  homepage "https:github.comcontext-labsmactop"
  url "https:github.comcontext-labsmactoparchiverefstagsv0.2.1.tar.gz"
  sha256 "740b78a672ab3b38be9d581cb0f95af7b669e46da77a66085b4e107cc0c8bbe4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a42a15c620d6fd05294aba91197fda2f5ccd1ddc0bb37612770ebe013e48ae99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe58f8f6aaf33dd031eb54f33083046b65f96d4802ccefba28d13c7a53d42942"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8e7b73f0fdcf478bd8e72e62eb604a8bbef82ac1a303dd11982eb764137067b1"
  end

  depends_on "go" => :build
  depends_on arch: :arm64
  depends_on :macos

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  def caveats
    <<~EOS
      mactop requires root privileges, so you will need to run `sudo mactop`.
      You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    test_input = "This is a test input for brew"
    assert_match "Test input received: #{test_input}", shell_output("#{bin}mactop --test '#{test_input}'")
  end
end