class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/usage/archive/refs/tags/v6.1.0.tar.gz"
  sha256 "4717ecff1ab445285f7736b6dc3b48b7ba949a56b33ea1a5228fd4d39564ad7c"
  license "MIT"
  compatibility_version 1
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "06ec0f8c035a17aec24482b4b71bfe440554c336bf5682dcb8a17ac7ecf4fca4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb4ac063aa9ecf0bc6d3edce6fae31e47e4916ea767118633e45175ab87c8250"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7c29f7108c3e6fe244ad107de71780a0a4ff3e18a76c4275b0571eae0f0010e"
    sha256 cellar: :any_skip_relocation, sonoma:        "615eb43c96ad0d1b3650bd94bcf446573c263e5da3020e8b3eeaadd6765b54b8"
    sha256 cellar: :any,                 arm64_linux:   "cabe3ffe2b612b69e452975a27d2ea83f98ea8ede1bece08e19688d9e1315e34"
    sha256 cellar: :any,                 x86_64_linux:  "9466fb9d9ab7f558da56b452a05c6b27b132b4b934e5c8c1b8428078330a23fc"
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