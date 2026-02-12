class TryRs < Formula
  desc "Temporary workspace manager for fast experimentation in the terminal"
  homepage "https://try-rs.org/"
  url "https://ghfast.top/https://github.com/tassiovirginio/try-rs/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "2b886bf2a9ff2da294fc75d067ab3c0695e1b8388d82a9399efd64a8e99476ff"
  license "MIT"
  head "https://github.com/tassiovirginio/try-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c983a05879562686ba45618e2be25f5999dd018e0585660b24ecf44f78df240a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35cc5c8f0553b81e54477066203bae8b0af78fe0f0d5b720566e822c2328c666"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "048605b4b9e02215e77185eacd4d487a92095c542cd4dda8205f3475470209cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f90f9447666114270f9533a4dddc09ae410a10a99b073bd2b286a10d978f1d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83ac4c5411bd7f3e17cc0e8d204dada0e17541dea95a1b34fc922f88ab643ceb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04f655ca91472ba51e1016bec99c9876e36ee78b623c629c9428debdb58a25f6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/try-rs --version")
    assert_match "command try-rs", shell_output("#{bin}/try-rs --setup-stdout zsh")
  end
end