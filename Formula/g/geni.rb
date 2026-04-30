class Geni < Formula
  desc "Standalone database migration tool"
  homepage "https://github.com/emilpriver/geni"
  url "https://ghfast.top/https://github.com/emilpriver/geni/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "84f49ef39e6c9a7725e25dbda9b751ce780e09352dd90b0eea86db4ab06dcbb1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e401951dd53c1937667b4f2de2294d5d53b0515d8839c362ef471c119224aa39"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24e009a27e515c4d86c161e3d01e16e32a16ff610ef1cca7b2ecd8495b5253f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c80fdded46bdfd69202ae4790908ae1b290f90c32e24b965879d9037aa7d7bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "930b7ee583452d372d6ade5dbe282c57c3de266fa0096203d7d27d0f12151baa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dcb99e5d87a513ce243fd304cd3367f2c33189802730f4dd2a5a22bd025c2a57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11c21a0e53a0850657f1b6bdac01fc37fb16ed31330139535a4e68c536db8a09"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["DATABASE_URL"] = "sqlite3://test.sqlite"
    system bin/"geni", "create"
    assert_path_exists testpath/"test.sqlite", "failed to create test.sqlite"
    assert_match version.to_s, shell_output("#{bin}/geni --version")
  end
end