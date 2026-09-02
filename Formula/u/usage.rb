class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/usage/archive/refs/tags/v6.6.1.tar.gz"
  sha256 "8cbb4c9cf294fc83cd22946c19204b82c4685fd61ec8f9372d64bff5ff4d0319"
  license "MIT"
  compatibility_version 1
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "edf0e1439443c5ec205325ce6392259bc352e538328cf444ac7287f6a4831162"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e33a59cb9b97f275866a9bafd656c1d4819c07fe2e9a8d49e4487b374646675a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8859e509bce6d6edc9ba9205fc04eb8f27858ec7df62e66e506df330b8de60ce"
    sha256 cellar: :any,                 arm64_linux:   "b6206dbd3ea11f8d7021d88f123b612d82d86233045e5fa40fa21c08bef8a254"
    sha256 cellar: :any,                 x86_64_linux:  "9e6ded147ec295ee07d9f63e426a922a8986b526c44d31ade1cc130922365bcd"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    man1.install "cli/assets/usage.1"
    generate_completions_from_executable(bin/"usage", "--completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/usage --version").chomp
    assert_equal "--foo", shell_output("#{bin}/usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end