class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/usage/archive/refs/tags/v6.4.1.tar.gz"
  sha256 "dc19be169ed66727e458ac06e9580d42db52e884941401cc2cd82d9c86e31dd8"
  license "MIT"
  compatibility_version 1
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "50de6a8b83e4ecbcd8b7ed3ebc406ee59982069e0f39dbfde1baf56faa6bd9a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f547ae144df4bc4230b87ae33b46ba12cb24b29bdf4d98b6b68590af6df5c047"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f7357a1801235de87764655a2c8c61d5cdbd83d5ce156843a06b3e01af1bcf4"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5e1d30af4faddbc4547e3c140acb0a60bd124a409777f565c4e175c0513f28b"
    sha256 cellar: :any,                 arm64_linux:   "2051232c880eeda880b05c3eed1b4341823630bafb4802a6af142c36b97bfec9"
    sha256 cellar: :any,                 x86_64_linux:  "10e633877c071c246d356f91abdfa74bb3e8c07dc561798aa4e2862b3fd9fb0e"
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