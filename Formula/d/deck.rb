class Deck < Formula
  desc "Creates slide deck using Markdown and Google Slides"
  homepage "https://github.com/k1LoW/deck"
  url "https://ghfast.top/https://github.com/k1LoW/deck/archive/refs/tags/v1.13.1.tar.gz"
  sha256 "514bb0316989c1d212f3c51998e9a71193a5a5196e22efa74e61dfecebf006c2"
  license "MIT"
  head "https://github.com/k1LoW/deck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df540702b55fbc8219f3eb96713be18f684143e08d41a6d5cdefd03769d400cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df540702b55fbc8219f3eb96713be18f684143e08d41a6d5cdefd03769d400cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "df540702b55fbc8219f3eb96713be18f684143e08d41a6d5cdefd03769d400cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe95c54df3c80a42792575ad7ff12c343398376d5cf8da4fa82cb8451e1a492d"
    sha256 cellar: :any_skip_relocation, ventura:       "fe95c54df3c80a42792575ad7ff12c343398376d5cf8da4fa82cb8451e1a492d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02926525141bddd155bba6672a794faab8ece8e29db57f1747b2e6092440dbf6"
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