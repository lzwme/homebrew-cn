class Checkpwn < Formula
  desc "Check Have I Been Pwned and see if it's time for you to change passwords"
  homepage "https://github.com/brycx/checkpwn"
  url "https://static.crates.io/crates/checkpwn/checkpwn-0.6.1.crate"
  sha256 "96b9c24f535d00f32031fe3b2d4bab9e6276ad5ad565b141ebf4f9d1bd197fa7"
  license "MIT"
  head "https://github.com/brycx/checkpwn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52a6b3eaa8d91838f553b3c2bf62de861bc598682fdb8a2e555184250d0f1608"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb40324086a06beec2f0a09343193141ede8d54c065d2a63ca505ae6e19281dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe0612a01cb7399ec573706fba582c89cad825d012c7829db1aca0f2fc1114a0"
    sha256 cellar: :any,                 arm64_linux:   "1e8426c2c2bfc07fdc43a1059da103205733f36e36efa8a54cffafead7e09585"
    sha256 cellar: :any,                 x86_64_linux:  "217bdc353245d2fd5adfe8f4f46e0ecb40a33077418c340f8a36ac96c416d14e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/checkpwn acc test@example.com 2>&1", 101)
    assert_match "Failed to read or parse the configuration file 'checkpwn.yml'", output
  end
end