class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.127.0.crate"
  sha256 "e5cfb5865ac2d60183b7ae3f9ed5bd258de9b7f05fbcce9fd40a70667c6e5534"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cbf45183bc6437cbd4e946a9b5f82539154068ddf5b2f2a7bac4825b15450f0e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0394b5d00479f76ad5f6277e9b2f5e2e45a1574df599bac3716d9e243d3531a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f702e612298b6c9eab46f074438c556204d5ee8f54686a3f05c299903320fca6"
    sha256 cellar: :any_skip_relocation, sonoma:        "47f863ba5a9dc167800a76cccee8669c8ce2c4dca8810c8b5fa31b497882163d"
    sha256 cellar: :any,                 arm64_linux:   "0d0e483f8304bcb963697933eb165b74ce67f9cbbc5a6ffae191f0584ba81d8e"
    sha256 cellar: :any,                 x86_64_linux:  "dd9df279c6e3cb49cdd7cee92c706cecfca7b7bbd69164781e89cb0131c82dc6"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ripgrep"

  on_linux do
    depends_on "openssl@4" => :build
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@4"].opt_prefix if OS.linux?
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    ENV["OPENAI_API_KEY"] = "test"
    output = shell_output("#{bin}/vtcode models list --provider openai")
    assert_match "OPENAI", output
  end
end