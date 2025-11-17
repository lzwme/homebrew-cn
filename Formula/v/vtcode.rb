class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.45.0.crate"
  sha256 "7f8a28c8ba242e4c1c87fd0c9ec4631d775d4275c86bd849fc9d0c12fa6ccab5"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "436beb90fb3ce856ddc8cc3d9a334a7d98eaa9cdb19002de08fe17f6b48c4898"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0eeaa8df207a677643d4ffd068926a5ab3db31d452f0e6c2df83af073a565562"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "671e9f2cba05754c58a6c2279da100de9fcef2b91c93a282180af0c1d0889dc8"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff627bdaa058af22252a98d42f1fbad6173ec7aa0e5a649d383d130f23bcb9b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac5136f7a12a7bd65125cb1ef62f47f2a3c7277aca8b2378944089fc254aea9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57667c5211339f83510ef0ef6ea4a17f6e16819448bb7aee361c42b2694c3163"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    output = shell_output("#{bin}/vtcode init 2>&1", 1)
    assert_match "No API key found for OpenAI provider", output
  end
end