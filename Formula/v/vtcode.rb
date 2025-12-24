class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.52.2.crate"
  sha256 "10ed08e7e36d28460739dc907b0daac96b89b21a23c79e43e562c91618958bc1"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ad7290548868396ddd99f2b44b76cf1ff8e6d1b84f623c7e6a34868cdb9ff5b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "099112a14e613519dc2ac834ffc618da7753e1bf0b9494e18c92594ae574857d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6c3801a0004e28111f3bc9b808ab8773385941763826a6d4c45f7f0cb67b47c"
    sha256 cellar: :any_skip_relocation, sonoma:        "00ef60396c29284c01c775c1ec3f8695b6d0439735b8136bba7e7a224527a768"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7754e60531a3e98d26e91707a2d011097baeef86eac63e83ea08a2c7ac572bba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f4a9c4ea544a7a24c1269464aecc3cac447421d21e1133867b4644f9420ecd4"
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