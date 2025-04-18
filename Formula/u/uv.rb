class Uv < Formula
  desc "Extremely fast Python package installer and resolver, written in Rust"
  homepage "https:docs.astral.shuv"
  url "https:github.comastral-shuvarchiverefstags0.6.14.tar.gz"
  sha256 "8aa675d84e42d3531fb5494bd519c418cdb419385d768f350a73a5e7a428bf70"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comastral-shuv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f83174f566f3b37df2dfdd1ba7893859d06dc32e76a9e4143d80e5d5a017801a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a57a40fa3fb77991db5c471d7c6d5d4e1a2a2d4dc6bde74f22185d38be8b1f0e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c5dada48e592a5b35e4dc5d8f7b38d3c29ad1ec4f19c111e42176f4069a4eba5"
    sha256 cellar: :any_skip_relocation, sonoma:        "3518b95d254f6a9f6dc6e52499b8aa0bd3892c67ace2ec64156db85b6be45c65"
    sha256 cellar: :any_skip_relocation, ventura:       "71211f21844014f9307a7059459b040e52f9182c1c96fdb400a94967ba099941"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03a64db7b24d4302988f869f1634b6d5e31278fbe860c241083b5cb47076f222"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "096437aac8a6f55124bc275e284a38db07ca4499db3563e44dd72d6989a178ff"
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