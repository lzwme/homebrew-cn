class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/usage/archive/refs/tags/v6.7.1.tar.gz"
  sha256 "cc0acd11a75634cf1fb110c1d93b9236a9f9187eb083856396d7f9cb2c19ac17"
  license "MIT"
  compatibility_version 1
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17bf79cba23969abaf148c97fdc4bfa1d35dd5a1bd4bab69f6f8b4f85a00ed28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b33815c731c3f5a90f64210c224e1d8700889d74e595052aff4445dd3ac64999"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab19218d9ffd194f55d53c415b1ea58a0058369cc8d82b6f8e6fed8ca98799ba"
    sha256 cellar: :any,                 arm64_linux:   "405e313bee87807a47ce9351342e6c42259b4fd3001f4dd507464d2a0e5796a5"
    sha256 cellar: :any,                 x86_64_linux:  "adc9d969a536e0c095db32fcb4d3177b90a80618dbdfd21381040cb43a3b462a"
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