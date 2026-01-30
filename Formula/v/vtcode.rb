class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.73.5.crate"
  sha256 "7eb222633b2fb3aafb435489c2d9b9ae420699d847c8daac5009719925509df6"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e168e9b0c11bb64ea44818a67c90a0d3655a336289d9160c0e3ea6eb7e21da7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "395395ef704d6e9ff33b5b18d3d9079be4a98769aa9e7872b9b82731c060284d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "062c7fcfa1d47b8b468f9d54f79bf1434dc71a686a2c08a965741863f6a241f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "4057a72e5f96af22e99b8d8f0c037c1306e0f672bfe3c63ee115857cbc04ef68"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0aa71590d11f1cc147830137899cc3741ca1735de88d8294523babe760430004"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d81c7c012985fc007ce34e92b795e73c091adb193ae73ae7413f8b03e2c48cef"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ripgrep"

  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    ENV["OPENAI_API_KEY"] = "test"
    output = shell_output("#{bin}/vtcode models list --provider openai")
    assert_match "gpt-5", output
  end
end