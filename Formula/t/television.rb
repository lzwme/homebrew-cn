class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https://github.com/alexpasmantier/television"
  url "https://ghfast.top/https://github.com/alexpasmantier/television/archive/refs/tags/0.14.0.tar.gz"
  sha256 "b3b93e0c1d1cd0b0ed0865bed0e129982f3ddb550b62a5c33554444257474b15"
  license "MIT"
  head "https://github.com/alexpasmantier/television.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc1cf4e500d6a1e12d0402ad074f365be41b721e76cfb3175b0d072699b8d67c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c45cb262552af0db001d7d31fdc4aa568ec5ec78466e17aeb5628d040286d74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed0bc6e55a7ca1558089054ed71bafa85d6ac8e97b83d34416285924d874f3b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8b84c2912363029e280fb09b03225467b7ebda2e64899cd36b76c564deb8595"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83c2b0bd012943e2b372aa86f76f1a0aaa77b45a4fe0b411ae25d4373b8e284e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e829d7259c428f48f3d92b47b3cc3e87115d536afccfe7cc4e17cb2bf21b593"
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