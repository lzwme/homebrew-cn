class XCmd < Formula
  desc "Bootstrap 1000+ command-line tools in seconds"
  homepage "https://x-cmd.com"
  url "https://ghfast.top/https://github.com/x-cmd/x-cmd/archive/refs/tags/v0.7.5.tar.gz"
  sha256 "363624f95ea504bdc3600fb6ec233baaa78b8c9b744180c112d8200338eab223"
  license all_of: ["AGPL-3.0-only", "MIT", "BSD-3-Clause"]

  head "https://github.com/x-cmd/x-cmd.git", branch: "X"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf246c936a9302fb69632ab380070c9d17c561c49358384f725a685b880e2ad1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf246c936a9302fb69632ab380070c9d17c561c49358384f725a685b880e2ad1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf246c936a9302fb69632ab380070c9d17c561c49358384f725a685b880e2ad1"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2b0deaa8f8c98f13542f9321fd8ab99a3d3f14d96c0e33d8bf48f46b73ca2e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "695b7915ab16305e5d96d0c49e7af2fc1ec1651cee1390c179bcb50fa3bafaf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "695b7915ab16305e5d96d0c49e7af2fc1ec1651cee1390c179bcb50fa3bafaf8"
  end

  def install
    prefix.install Dir.glob("*")
    prefix.install Dir.glob(".x-cmd")
    inreplace prefix/"mod/x-cmd/lib/bin/x-cmd", "/opt/homebrew/Cellar/x-cmd/latest", prefix.to_s
    bin.install prefix/"mod/x-cmd/lib/bin/x-cmd"
  end

  test do
    assert_match "Welcome to x-cmd", shell_output("#{bin}/x-cmd 2>&1")
    assert_match "hello", shell_output("#{bin}/x-cmd cowsay hello")
  end
end