class Macmon < Formula
  desc "Sudoless performance monitoring for Apple Silicon processors"
  homepage "https:github.comvladkensmacmon"
  url "https:github.comvladkensmacmonarchiverefstagsv0.5.0.tar.gz"
  sha256 "52310fcc04cf7b6ff66f2b1232ac1d4f1aeb317430fc4393805dd8bd035922a8"
  license "MIT"
  head "https:github.comvladkensmacmon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73d7635d5fabd0e0e83ccd2c3e36f73ac35a53467b5d84857c6614a80939a0ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb13be0795f22aca1375ad1149498187b687feaef44f568be036a62d5452b2c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f5c9f42a2f9f7d5ab7036dd02bad1d181eeab52893bb0fe2a06a746459fcc615"
  end

  depends_on "rust" => :build
  depends_on arch: :arm64
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}macmon --version")
    assert_match "Failed to get channels", shell_output("#{bin}macmon debug 2>&1", 1)
  end
end