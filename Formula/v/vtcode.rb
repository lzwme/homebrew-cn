class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.84.0.crate"
  sha256 "e8a08458ae632e893926406dcba027fd87c5dccd3bdc8871009ccc598792442b"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a83b26aa1f4927746dba9b7d60898b576c99caadacbab6a3fd6fcae3ca25619b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f81cd714309806412074443265d837914e671c9f7b1eaa0378ad14b160d8b963"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3443eba09f1a7e04fbf0bda7cddea5802fd9660f131e26af2a0cd2346f6d4ca2"
    sha256 cellar: :any_skip_relocation, sonoma:        "953b76054ec8990dae9223c29023438857ea27ea76ef648f3d10eeeae2e2cfe2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d196b3e06cdb109d786009fb3c8fa8158b6576e2ec4b357b6e7ff4313c70fa83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7b7ea2ac95ae7329da4d7896ceb723f9f3654ef101b5e93c8639e2a79715b8c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ripgrep"

  on_linux do
    depends_on "openssl@3"
    depends_on "zlib-ng-compat"
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