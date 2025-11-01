class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/usage/archive/refs/tags/v2.5.2.tar.gz"
  sha256 "57da6fb5639e70c401766daec90948ee043a23568e568a2e571c605ce278d410"
  license "MIT"
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9277a06abfb964b8f64f7eb2174f8cc555dbbead1480a93e09038ad583870b46"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "074d654317f2a125bb6fda59cc0deaeeb4302610608d29cc5dd0be47c1761c26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb6102072002d32de552931f2dc6e42617ac7b5c61dc093e71ebeeb9929d8fa1"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f6c65322af6f9d084bc33b17cfa5a73a4f87d7a9393c1879efd7c633dc415f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f056eba8cabe82bd14976326ef556c4b5056c21d83a2b88fd5b60ceeae2d9b7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96ba406b475b26638e1fee116576b77ffe256f55e317278566db664a88b876ee"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    generate_completions_from_executable(bin/"usage", "--completions")
  end

  test do
    assert_match "usage-cli", shell_output("#{bin}/usage --version").chomp
    assert_equal "--foo", shell_output("#{bin}/usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end