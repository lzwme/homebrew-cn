class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.106.0.crate"
  sha256 "cbe34beb59ddc107c23b423a7ad698904747392448aa2a5eac3150a226b66363"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91ea640570e6f41d57fd3976b1e2ef980ff513f40a6c1afc12be311db9a395b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2e2b87de0faa6a8ebcafc8b2ee1756c9df28f6490ea55d4cc3e2d0260d911d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab045ab2b229e66b601277f8a89374845d8e3dcc405642020410566740737da4"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf56c8cb6bbb086e6d41583e9db40e2635631163d02a65dd1e3678da05208388"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d11d04a64785a498c6ac59bba9d0700632388b7402291da134292101ac81495"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49e8823f0161908e476e1c9b22c2469a1e0b90a6de1e5a53fdd1bff2a2cdad66"
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
    assert_match "gpt-5", output
  end
end