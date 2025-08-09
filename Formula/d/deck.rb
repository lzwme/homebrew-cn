class Deck < Formula
  desc "Creates slide deck using Markdown and Google Slides"
  homepage "https://github.com/k1LoW/deck"
  url "https://ghfast.top/https://github.com/k1LoW/deck/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "033f4f8630986624025325a4445d836da3f2c700351b3e186b78f345de34d3b8"
  license "MIT"
  head "https://github.com/k1LoW/deck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e11709201407b3044305352973f45cb781197f1a02a1e5d5e36b2c2da3ac7aef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e11709201407b3044305352973f45cb781197f1a02a1e5d5e36b2c2da3ac7aef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e11709201407b3044305352973f45cb781197f1a02a1e5d5e36b2c2da3ac7aef"
    sha256 cellar: :any_skip_relocation, sonoma:        "8417084a51917e08d46e7d571b4f82bf7f220501fe4146febbe4b7f4d0438a74"
    sha256 cellar: :any_skip_relocation, ventura:       "8417084a51917e08d46e7d571b4f82bf7f220501fe4146febbe4b7f4d0438a74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9e5b85c781b054cd0b15e5156f06b24872e9c63605d7588717627c3cce5db31"
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