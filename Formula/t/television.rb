class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https://github.com/alexpasmantier/television"
  url "https://ghfast.top/https://github.com/alexpasmantier/television/archive/refs/tags/0.15.0.tar.gz"
  sha256 "379573f0d45cc03abb71174c4e76b4e875500fb67df511bb1c106d814417fdd5"
  license "MIT"
  head "https://github.com/alexpasmantier/television.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c2354e83e665328cf98114863246a13066fe945f3179cb0af7673bd64fc78a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7df1ffa568fd40af957af3bcb2b3e1e0f9a767c3ff06e142b17937282da53c67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a5e843af0b21f406dd922f59bfa68b285f13caf365e7d3493826b29ceb7f58e"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ac830a45c108bd481f9beaa9ed39a32f2d515d3534a93d9a4808b1ac4e422d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e504f0cffcb6f3a0479274fd8a63f8ac8d401de5a26af33b85e454ec128e09e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49fc17bf8c8fba3ac45c5ffb268f616e944a8c97f774fcf227c856f5d0f29ad6"
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