class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https://github.com/alexpasmantier/television"
  url "https://ghfast.top/https://github.com/alexpasmantier/television/archive/refs/tags/0.14.4.tar.gz"
  sha256 "039d554569117c665e1b4336c427747a118cca781ddbffaf701c4b5f01c7f3e1"
  license "MIT"
  head "https://github.com/alexpasmantier/television.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71e42a92ba666328bf1d1ef5a9fd9a175fecc75762dd4f65e2f7ee071c1c36a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c20a029ddab223dd6f4e5cfc3aa262d47652220a92fe55b49b1e70cadc97fb5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ae7fca67f9d22f3485f397ecbea7341d0f32da66d5fe81484c1bed71b4275c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "980009a0473f18a84a7e216d7a46b7a2d5d679c0ec9009a67d23f01ac2582ce8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d18d3aefca5ad63ebf03df652c5dc72448ad89dff995dfffc9685d25ed470ace"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad6e8e20d20ed7746a716b15679c7b6a95e837d44f88215e739dd2aaca2995c5"
  end

  depends_on "rust" => :build

  conflicts_with "tidy-viewer", because: "both install `tv` binaries"

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "man/tv.1"

    generate_completions_from_executable(bin/"tv", "init")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tv -V")

    output = shell_output("#{bin}/tv help")
    assert_match "fuzzy finder for the terminal", output
  end
end