class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/usage/archive/refs/tags/v2.16.2.tar.gz"
  sha256 "50c1f44d620cf36c3126bfd8c9abda7bef9fe592cd85cfd599d0fbb6a866fdf8"
  license "MIT"
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "efcd701deaa9be0dfc467571146e41f87292346b7e5de912520928708c7c3309"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53602b541107a204fabd67e753623e4d0f6503ab5106f70495f0c429e603d350"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad5280d12e3ad70444c0a7c22e563cb567fb0268b443e5a8aa4a36bb142bb658"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6d30ac36e37fa376e9bbb27feca46059d06eca98b4f01427b283b0801e0db37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "543a17d2e8dcefb3e9dd635954f5e1fa74ee100ee78c54e894f5362c06da5e61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e0acd9cfc5e4350ab91d787f9909ccc900be5a19a7c8f1d4d824895006aadfb"
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