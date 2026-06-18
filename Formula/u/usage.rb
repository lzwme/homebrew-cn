class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/usage/archive/refs/tags/v3.5.2.tar.gz"
  sha256 "05e0ad29b451c6816e2845556c28eae46bf96f58712a8b457ef1b9907dba533f"
  license "MIT"
  compatibility_version 1
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5842ae4cf1e49202cac9038daa9093c906134af4cf296e8d0faae96c6b6b3355"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2ebcc78c6fd48d956b3f2a5a4af80ebb9f8340aa1cf4718da9a4ba60cce49e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f32adca33b9f69180c12f2e22771d944307e28f0585efba2b3dbf7b8b2540b89"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4ece390d2d96138bd41fbdd2895806c3fbb5d3ae16ac964f18a305aeeb83249"
    sha256 cellar: :any,                 arm64_linux:   "7591d5139a97cd3c55051f5db83af6b0022735b9cfecf5527b42c08feba57805"
    sha256 cellar: :any,                 x86_64_linux:  "83f9b40fd25e329422f869c4f5e5856aec09593c5dafc00d6cf6839b62c70a66"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    man1.install "cli/assets/usage.1"
    generate_completions_from_executable(bin/"usage", "--completions")
  end

  test do
    assert_match "usage-cli", shell_output("#{bin}/usage --version").chomp
    assert_equal "--foo", shell_output("#{bin}/usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end