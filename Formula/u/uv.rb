class Uv < Formula
  desc "Extremely fast Python package installer and resolver, written in Rust"
  homepage "https:github.comastral-shuv"
  url "https:github.comastral-shuvarchiverefstags0.5.28.tar.gz"
  sha256 "db7bf999d0ffffce9eb2ab9f3366d013acdf4f6287b4daeb5627d481147d3c68"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comastral-shuv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b18318173fa4607f583d4ae7bb4fbf92cf81a9e60b2b44da8a79ace2da077ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5af65b6e765bd73abcb2ae2c6e8e89c9e29af88a069e9f24d8e7e607fcbdd20d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4e46b2115f6a7d4019b3ca25e61176357dc7b5c16927f744f63d68dcbe90b4c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "85b86d3edcb9084786cc3f4d2deac3eac9168a174e8fd58fce01c5c81f550c30"
    sha256 cellar: :any_skip_relocation, ventura:       "035a700282dc7e2f0203d6a5120f80acefea00b13bbd3b1028bfe505e4583aff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3e03193bb75d9a205d358229be41bb9837053f4028e198efc7c5143f757c645"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "python" => :test
  uses_from_macos "bzip2"
  uses_from_macos "xz"

  def install
    ENV["UV_COMMIT_HASH"] = ENV["UV_COMMIT_SHORT_HASH"] = tap.user
    ENV["UV_COMMIT_DATE"] = time.strftime("%F")
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "cratesuv")
    generate_completions_from_executable(bin"uv", "generate-shell-completion")
    generate_completions_from_executable(bin"uvx", "--generate-shell-completion")
  end

  test do
    (testpath"requirements.in").write <<~REQUIREMENTS
      requests
    REQUIREMENTS

    compiled = shell_output("#{bin}uv pip compile -q requirements.in")
    assert_match "This file was autogenerated by uv", compiled
    assert_match "# via requests", compiled

    assert_match "ruff 0.5.1", shell_output("#{bin}uvx -q ruff@0.5.1 --version")
  end
end