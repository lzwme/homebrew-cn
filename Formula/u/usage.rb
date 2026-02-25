class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/usage/archive/refs/tags/v2.18.1.tar.gz"
  sha256 "9dff640538dd4f7492008f7e9d917ae1f2afc94717e79e27ff3e7d12d9c00148"
  license "MIT"
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62fdf229b870a7ad3112bf7cc8d896b61edcc8aab9b343257ef0d9ae5b047c1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "616c6de0c3b91afac07d0734710aa0a21402f0c1c4b8a18bfc5ec28976d8f14b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec4acf4340cbaa4663998b58749e7badc48be3dbea05bde06f083d1efd443d7e"
    sha256 cellar: :any_skip_relocation, sonoma:        "824513f10591e6826eaf59b85458afe8997cb4965c1952ad7ba34d161bb28fe7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd382bd2d305623cea2fdd411784879bd032d1d90ec347fe6dda88bc1b1a0459"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "414a59dd70db84b4f2c065582b82118bcf7d775012956735092f36966804de5f"
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