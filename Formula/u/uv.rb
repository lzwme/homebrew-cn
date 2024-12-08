class Uv < Formula
  desc "Extremely fast Python package installer and resolver, written in Rust"
  homepage "https:github.comastral-shuv"
  url "https:github.comastral-shuvarchiverefstags0.5.7.tar.gz"
  sha256 "e259e93e264b83f9e89e1d81cab1dfc13e762d110e48c6866d5ea201bcc38278"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comastral-shuv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea347980dad2b23f1a0935e9a45540c4ae1054e96bf37e73927c55c00590a993"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f4099222457cadeb8ac1601416cd763425404f2bf7a9321daa5c2a92a5d7901"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2bbb61bdf97f7941811f5934d50a4a2a9bb4a0f69aca9846d86b6c5967e877fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "196883a1f227e4d932c5134dcad604311937f307f2dc179fc7da8c9e9a93ed9f"
    sha256 cellar: :any_skip_relocation, ventura:       "a4d5c0ae59fa93e1ed823635e47464f2355791c32c021be3778a1eefabfabc9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70fe1de5dfc619c06ff42b00cacb6e42b0edd8b2dccb8f64282afd3f4830e790"
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
    generate_completions_from_executable(bin"uvx", "--generate-shell-completion", base_name: "uvx")
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