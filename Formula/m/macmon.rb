class Macmon < Formula
  desc "Sudoless performance monitoring for Apple Silicon processors"
  homepage "https:github.comvladkensmacmon"
  url "https:github.comvladkensmacmonarchiverefstagsv0.4.1.tar.gz"
  sha256 "19ea622ae09d508b89be7869e45ddc3854a4441e40d0ae28ee16d6a4d621b724"
  license "MIT"
  head "https:github.comvladkensmacmon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10cfb38492617b1a8727e2a48f183f2c013b19b457af3a912928c66da62781bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "736a9607ac2f535c9327a1c0c401ab2117030f5cb6bd151ab6508d371bc272cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9b121143335c0d8ced34ca3d8f67ea6f89c706727aea90e37af1a27ffea85cdb"
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