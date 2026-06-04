class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.121.0.crate"
  sha256 "49579dcd38402565dc524dca60e5d320d10490aeeeed1b27108736dd0e56ba9c"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "615f6ffb959d6ac0a54759a98b66d97724fd7fa7c91fcf0920ba73e71716320e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36e9532e9b178cc7b4226dc46760aa6324a9ef7155a58e2c3e41398ebc365fb6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "491ac569b18831e80db4ca6ab5bc2bedd79aa5b0f24de27050b576a4075112c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "021465e6ce586c9611e22bdafc169534a1b209b821b31154df19955a29b54e69"
    sha256 cellar: :any,                 arm64_linux:   "04ec5d6e436fdd5a9efe216e8190cac678375d76a0d475eea239d363e299c90a"
    sha256 cellar: :any,                 x86_64_linux:  "87de103da2bedeb7af73909db7d8297a676a840f978f31d5557e2c3890fbc273"
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