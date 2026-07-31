class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/usage/archive/refs/tags/v4.1.0.tar.gz"
  sha256 "fc79d42555a75bddf8bcc0cfd3f0f3d03c2d086703ef6e05efede19b85368be7"
  license "MIT"
  compatibility_version 1
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "318fd861234ed477a0e35586a457b3a76c672ea88ff1c22165b94845da880f42"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c731c4dcd5b203fce8911ba38a4a7801c43ceca1065c75ccc2b689f0aa1d01b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c2ac1f02f1b8bab6dd1a066e39205f7e7f65460905dfbaa93a97f5e5ddaa2aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b207b2be711cb713a88e85c12b3d4cf3b47f9468dbf6126fa5e284b694ed64d"
    sha256 cellar: :any,                 arm64_linux:   "9ca475102caeb5f6cc0d0798233b17c0c9cd06abed233922dae4f9bdf1bf4595"
    sha256 cellar: :any,                 x86_64_linux:  "b4407957c4395c477b91363c4cb97e0a074b037d844c4034b7ba0ecc7566166b"
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