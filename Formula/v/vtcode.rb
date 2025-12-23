class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.51.2.crate"
  sha256 "ebb05836711220598df82d1b06c4932250e2907fb7fa2520e22ed4bb247d7ba7"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6a8dcc60804f4cae0d0619b9ec5b81e2a325681344adb0cde5ac1ba4bf07ff8a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c650444f0848bbeddc928f768d68bdd67254f81d702120ea020a3698891f8b32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4731b23234f782e91320f2f4ac70ca2fcae2f897c49d2152a6c86f47ba34b35a"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9eb85eb7e54f0456cbe740a810e93ff43b0b77cc3a102ce51ce4c7bf73d96c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b3a7ffd06cbd7bfab2ae8728a60a50e72a16be2390cf10a6517d94d2e33a189"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "666b540c7bfcee97b28dce4fde4c4d9fb8173a0786910944aebad4cb5671e9ff"
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