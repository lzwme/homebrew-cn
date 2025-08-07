class Minify < Formula
  desc "Minifier for HTML, CSS, JS, JSON, SVG, and XML"
  homepage "https://go.tacodewolff.nl/minify"
  url "https://ghfast.top/https://github.com/tdewolff/minify/archive/refs/tags/v2.23.11.tar.gz"
  sha256 "d2eec8d7d5a713476d4eea491c3b0da0d9391721eba6e71b00d5855d26cc41dd"
  license "MIT"
  head "https://github.com/tdewolff/minify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4581da060317c3a8e533664087e275656bd871c4883e1fe3e545691663c904e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4581da060317c3a8e533664087e275656bd871c4883e1fe3e545691663c904e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f4581da060317c3a8e533664087e275656bd871c4883e1fe3e545691663c904e"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b1123f462041342fdfbc92c14e8ace4811e63edc6cf6e1a761f338b5d74c35a"
    sha256 cellar: :any_skip_relocation, ventura:       "1b1123f462041342fdfbc92c14e8ace4811e63edc6cf6e1a761f338b5d74c35a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e15196b6d9314e7d05c5888b78c5db3c8dee844a8a255b3fbe35137985c52f19"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/minify"
    bash_completion.install "cmd/minify/bash_completion"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/minify --version")

    (testpath/"test.html").write <<~HTML
      <div>
        <div>test1</div>
        <div>test2</div>
      </div>
    HTML
    assert_equal "<div><div>test1</div><div>test2</div></div>", shell_output("#{bin}/minify test.html")
  end
end