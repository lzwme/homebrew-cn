class Deck < Formula
  desc "Creates slide deck using Markdown and Google Slides"
  homepage "https://github.com/k1LoW/deck"
  url "https://ghfast.top/https://github.com/k1LoW/deck/archive/refs/tags/v1.19.1.tar.gz"
  sha256 "e415edeb49433b8bcf36baedee07e0ff49827ce1b226b1136e5630446edb066e"
  license "MIT"
  head "https://github.com/k1LoW/deck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca7bd4fb8c014b5b486f7956094539116d0c784656c2eb73b0e228431b69fedf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca7bd4fb8c014b5b486f7956094539116d0c784656c2eb73b0e228431b69fedf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ca7bd4fb8c014b5b486f7956094539116d0c784656c2eb73b0e228431b69fedf"
    sha256 cellar: :any_skip_relocation, sonoma:        "881f4e6bcf59fb34344af4a761251a459dfb01ea83d3653448f0da0fd9a1c032"
    sha256 cellar: :any_skip_relocation, ventura:       "881f4e6bcf59fb34344af4a761251a459dfb01ea83d3653448f0da0fd9a1c032"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aba52578c4dde11b4a8005b3f8333a93ce0e72ee09e0ad0f64380f31d7aca811"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/deck"

    generate_completions_from_executable(bin/"deck", "completion", shells: [:zsh, :bash, :fish])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/deck --version")
    assert_match "presentation ID is required", shell_output("#{bin}/deck export 2>&1", 1)
  end
end