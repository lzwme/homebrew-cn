class Slumber < Formula
  desc "Terminal-based HTTP/REST client"
  homepage "https://slumber.lucaspickering.me/"
  url "https://ghfast.top/https://github.com/LucasPickering/slumber/archive/refs/tags/v5.1.1.tar.gz"
  sha256 "7ef5045fe3fb1def67ac9993eb0d10e20f02d3cbff4a6fc7c07a588b44119565"
  license "MIT"
  head "https://github.com/LucasPickering/slumber.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c9ad0aa3e9da1f59059ac3d9c21010d95598f5c30ac7e60aa46845b1e9a561eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbff3c20854f34dd47e0aeefd7ed6be8a5a5c054f7e725ef2a149ae5f4c44354"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cca934cedf1b788c1b6f0ba17f990618e8696df47145f5e620eedd0247767018"
    sha256 cellar: :any_skip_relocation, sonoma:        "982a70ed5c0839f99c96f5909f0a7dcd568d1a8dd0bcb969a834cfb8e10b9c4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b11aa99d038e34dccb7b4d0b694ae11d51dccf2162a551e4bd7797510034758c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e65ae5f26886b481e7369e90abc2ba5980db4a9c610d249f8cadc4e44129887"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slumber --version")

    system bin/"slumber", "new"
    assert_match <<~YAML, (testpath/"slumber.yml").read
      profiles:
        example:
          name: Example Profile
          data:
            host: https://my-host
    YAML
  end
end