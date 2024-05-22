class Mactop < Formula
  desc "Apple Silicon Monitor Top written in Golang"
  homepage "https:github.comcontext-labsmactop"
  url "https:github.comcontext-labsmactoparchiverefstagsv0.1.7.tar.gz"
  sha256 "0a449c4f9e1adb95f6440e1cd4438e72501e8485ea5ed390d6cebaddb29dcd51"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f954130993d476e14279ca7e6742892fc9f57172cfcb3a05e36b0c7a7b6df37e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5407358518946c9c69428328c060dd994721b5021bfba5c8488f4fee07530bb6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb626cee7a0b7101b3aab9fd380c2a95d3509001cd06385e6567a6ca1c8f1f1d"
  end

  depends_on "go" => :build
  depends_on arch: :arm64
  depends_on :macos

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    test_input = "This is a test input for brew"
    assert_match "Test input received: #{test_input}", shell_output("#{bin}mactop --test '#{test_input}'")
  end
end