class Mactop < Formula
  desc "Apple Silicon Monitor Top written in Golang"
  homepage "https:github.comcontext-labsmactop"
  url "https:github.comcontext-labsmactoparchiverefstagsv0.2.2.tar.gz"
  sha256 "bbba285a00f7d2f92615bcb18adfc5d8ca0c94b801bfcf67e0084ad18882f4f9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbb2efba1cde25e02d118868b613614edcb9d5721fbdfc1914779b0c7eaecbe1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4af1cce5162a999052c570ba75276c0e333a9d5d8ab161b92b0ba4973bcdc0f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "71459f7e0305f2577643a4be872af504d0a6a4bdb42cc09339065b980b3a923e"
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