class Deck < Formula
  desc "Creates slide deck using Markdown and Google Slides"
  homepage "https://github.com/k1LoW/deck"
  url "https://ghfast.top/https://github.com/k1LoW/deck/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "455b82bbe9dca83a8d62c170a6909f428bc7b00a17c8798e43c89317d9942aef"
  license "MIT"
  head "https://github.com/k1LoW/deck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "455b97e333336c4774bf113238b8d9e3023b86cd4e6a2bf227b2eb5a37ab8159"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "455b97e333336c4774bf113238b8d9e3023b86cd4e6a2bf227b2eb5a37ab8159"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "455b97e333336c4774bf113238b8d9e3023b86cd4e6a2bf227b2eb5a37ab8159"
    sha256 cellar: :any_skip_relocation, sonoma:        "8434e262baffb17e25389a45f7551e96a73ad6b542e412e110c3208aff43f8ea"
    sha256 cellar: :any_skip_relocation, ventura:       "8434e262baffb17e25389a45f7551e96a73ad6b542e412e110c3208aff43f8ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "866980163747e9f958493bc94e569a75894a5963e1eff6b74e50f5beb2b38e31"
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