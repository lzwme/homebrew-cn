class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/usage/archive/refs/tags/v6.11.0.tar.gz"
  sha256 "44ca23fcd407d9d871c00a3151034a4250981c2b31996f9a901130b674aa6e99"
  license "MIT"
  compatibility_version 1
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1b9deeffe550f0ccdfbf240b4bbd0409a052f5c9a3f2453939d0c8d472c3c8aa"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6f53fba56ed7edd80c65bf576681fa1692016971fc4b4fd7baa987c815ee89f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b5c07acd2a38ad1bf2aeba3ed530dc7ab6c17ba7300f4c12f78861707f7ca868"
    sha256 cellar: :any,                 arm64_linux:       "da818053868f60064ea6a0ac96e996f7fa27f8a33714a032aea6f1ec82602912"
    sha256 cellar: :any,                 x86_64_linux:      "d05f9b9bbad25e062fb4d4f90b2333409c1b8e63cef306f3c7e0533c6e997bc0"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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