class LeetcodeCli < Formula
  desc "May the code be with you"
  homepage "https://github.com/clearloop/leetcode-cli"
  url "https://ghfast.top/https://github.com/clearloop/leetcode-cli/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "af8993b4f2d9988638223e9884b397c32c14bdf45a1ae3fd869e247e8900704f"
  license "MIT"
  head "https://github.com/clearloop/leetcode-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51edbeb76f293c0534cbce79182facb000dc916d0b12bdef14cb6d55de226c7b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7663844efcf9b2a3cff7f03266aec4bafdc57ce3a2317724779d47e4b800b0bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bed877ceb29394fdd6f90f54100eb4dda9f31f78d1c712a4dce50c8d17174844"
    sha256 cellar: :any_skip_relocation, sonoma:        "051d713afeb0e42bc4a050ab5702c2c7955171c589eb4466819752b860a536c9"
    sha256 cellar: :any,                 arm64_linux:   "fcad68c9a458808f6e9aee87b0997ce8a1ca11ccce136c460baf6dcd1034b17f"
    sha256 cellar: :any,                 x86_64_linux:  "d5db3ea89bdb74584bbcfee66c5a831a112d8972af7820e47df14d40bf3e4818"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "sqlite"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"leetcode", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/leetcode --version")
    assert_match "[INFO  leetcode_cli::config] Generate root dir", shell_output("#{bin}/leetcode list 2>&1", 101)
  end
end