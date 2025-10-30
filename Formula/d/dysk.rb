class Dysk < Formula
  desc "Linux utility to get information on filesystems, like df but better"
  homepage "https://dystroy.org/dysk/"
  url "https://ghfast.top/https://github.com/Canop/dysk/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "6c5855f439efdc42c1dcebf41e0349ccc9daa543f83dac49f9901c66bc53257e"
  license "MIT"
  head "https://github.com/Canop/dysk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0db4ce93832ef935bd0f986e545b3a7d1d7fe8649a2565c7071b87c2ec3348b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e2fb4e7f10c21d4d300b46947d0350bab9053ea2a882bbc92eacb12c08c3c04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1542861a6eeb1067531ac3eccb34256321072039230c28ff00085f08ec799815"
    sha256 cellar: :any_skip_relocation, sonoma:        "f842d9977da947a0376bb31c8460e6eb610a76c3656079bb7c5873b2c33d711f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e73b63bd57f566dd91984bd269b8e54d17970f8e93d9adca0f1bf474499c3cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b33baf330cdfd578688adf24ca62764d01cdd564e9521d6a563f9f7371f1b88d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "filesystem", shell_output("#{bin}/dysk -s free-d")
    assert_match version.to_s, shell_output("#{bin}/dysk --version")
  end
end