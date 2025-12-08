class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.47.12.crate"
  sha256 "6d7894ac408a1cd3ecf85f4434cf54dfe434e07f67ece6d25cf29db0292812ca"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51628599ab5da09d6c98ab522e2abf81f91422d00ba5491e895bffcdcac8ca4e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0454e42b5539b521fd5009353196b973e54d6e08e5219bf28049f46e579161d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6fcf0c6303a306c22a5ee023dfc2cc50dced773000fc117d89e61b9f34530cc6"
    sha256 cellar: :any_skip_relocation, sonoma:        "adf29198934a95a566785b5bb4ffad31efd48fbbd30f0170279339bf6f375278"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02f49f1d95096ac0e188528d68a391d0b9a5ab038839a3869877aa693ed07ce4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0ae03471dfe0835dab6c77ecf64934c058f6496e6db6319b3504895aec1f264"
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