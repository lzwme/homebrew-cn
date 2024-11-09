class Uv < Formula
  desc "Extremely fast Python package installer and resolver, written in Rust"
  homepage "https:github.comastral-shuv"
  url "https:github.comastral-shuvarchiverefstags0.5.0.tar.gz"
  sha256 "28d44c0a8a8ad96e7d9c6ac02f56fbe5c0deffa0c12c877d4abe6841257ebb61"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comastral-shuv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb8ac4a651dbdc1cf92b718c99404683325a456694095b953bb759ece86c45fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab0a42ca9b338626f1d7137ba6ba33b7f04b7951b83f6ed6cf2904133278cd7d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dbe0ab46a31f441b45f7659ac82a2dd949f0d8a1abfe3dc9f8262bcccf7de0e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "8fe9e1fb03b64b03cadd7a3a59a9b3f4e00071e7dac6c5445f397f53259ee446"
    sha256 cellar: :any_skip_relocation, ventura:       "1ae66e9217e8cd02411f625e86e50705512acdcd37401c01e8d2dd2a115fbf0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d83c1224e0e253a19a72c3157d5d71609c9eda92bde197344b605cfee8924222"
  end

  depends_on "pkg-config" => :build
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
    (testpath"requirements.in").write <<~EOS
      requests
    EOS

    compiled = shell_output("#{bin}uv pip compile -q requirements.in")
    assert_match "This file was autogenerated by uv", compiled
    assert_match "# via requests", compiled

    assert_match "ruff 0.5.1", shell_output("#{bin}uvx -q ruff@0.5.1 --version")
  end
end