class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/usage/archive/refs/tags/v6.8.0.tar.gz"
  sha256 "032842fa48ccfcd0c2ca854105c25184cf3ed17250f596f21c4448b0148100de"
  license "MIT"
  compatibility_version 1
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "816191b28f5371aa4c49e8bace6021436ca8fbefd9231bd848c22f25878223ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f03aa07243329eec5dd0faad2b8d48d4efac3c0a37c2213222b80a22d0938ddd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79484b39206d9e449f2ce06371690af0551cf444248ca155bb19bb0c47ff178e"
    sha256 cellar: :any,                 arm64_linux:   "7a9a3e2b6398efdfb24a64d2310b76c2f723948c29e6af44ce355fea150e7ca4"
    sha256 cellar: :any,                 x86_64_linux:  "2998241762ae71d56624613eec97ed8514e585662375d30c38575eaaa741012a"
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