class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https://github.com/alexpasmantier/television"
  url "https://ghfast.top/https://github.com/alexpasmantier/television/archive/refs/tags/0.14.2.tar.gz"
  sha256 "ed0860cef855013d93667f61ed4c17866e63ac0d7dd95ab5621aa61771d27255"
  license "MIT"
  head "https://github.com/alexpasmantier/television.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd25ef00e7c016f47c8ea49b37e03328dcc4012b64a8b4b95513d6a21dff77b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d31863f6dca7307f6decb958fa65baba5fc57fa4d84f4a55d3e1570e484d51f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c67bac27afacd7f97209ec47704af36996eac33650abee1fa13855166a01ab2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8f5e6143a6e1bc1702b0a30749c982819713e9575eaacdda73ee57bba766245"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ff62b66dcad00adf52b2dd32495227cd1c7398f00fa120a4c6ddad3f72b4411"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af5338629920d17ee6e2fe46be31fb048ec21fa3b5963c1eb76c6efad7f06a67"
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