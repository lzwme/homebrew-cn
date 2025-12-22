class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.50.13.crate"
  sha256 "000536af88edde8b3d0ebd40a1ec860f470c30910bb6cb272e12f50036f4228f"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ebc5b60d97b10446b745a65b0240b19a36c0b04d0b441e85c9a867666067e17e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e4da177739727bcc909e163847eecafb9ff4922cf0ea84fff00e831bdc285e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3fe58120c4b10f63d7badad2c353408b4c6903e171b44a99d4630c7be3b524f"
    sha256 cellar: :any_skip_relocation, sonoma:        "23e5f974fe5e90667b3be6035b83e11412f271ed5d5b6dd0ace1b6489811e00d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3bb2ce76cab6faf4cfe975b1e989a4c4924880a8e32d4cafa8cf6142ab4f083a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9da511d93d524edbb0fc2ae8158bc1df607b0148123e7e3264aecb29678ff98c"
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