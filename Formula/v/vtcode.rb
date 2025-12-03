class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.47.7.crate"
  sha256 "84f1bc7491c80e1e40172d7677413a17c406f05006d6c26d5f051c67da9b9f08"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d32b62814a38f407ac0e229e510d658a2fa6223a0c671b8f2c6dda7072dbf6d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58714a089eb3d17d153f22fac82f867784d93f7ef6685cebf118a6a4df71d4ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "935aa6f3c0536bd57fd4e0268184f8e2cbd84ddde43d351c0d73fb8bccebb55f"
    sha256 cellar: :any_skip_relocation, sonoma:        "0acb687847a9dc94f8c34612dfbc2632dbedcbef9e2d3964f35a42d3fc59936f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47712a9ec901fc4a92fa3c419e0383f7ff1e0bcb49da87699152f967255ad525"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5651fc56e8c7b88e99c8e7447a4a8034e04ad30ad25be8e82aa10f83fd808808"
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