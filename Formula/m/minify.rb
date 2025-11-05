class Minify < Formula
  desc "Minifier for HTML, CSS, JS, JSON, SVG, and XML"
  homepage "https://go.tacodewolff.nl/minify"
  url "https://ghfast.top/https://github.com/tdewolff/minify/archive/refs/tags/v2.24.6.tar.gz"
  sha256 "18ea9ff2d11789e69a7b9f835e75abe92d75142bfdf70e53bc3445e44ea06e94"
  license "MIT"
  head "https://github.com/tdewolff/minify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "25f9cb306efb588b1225b7a8f0842719ac48d6c59b9489efb4add0710029ff68"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25f9cb306efb588b1225b7a8f0842719ac48d6c59b9489efb4add0710029ff68"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25f9cb306efb588b1225b7a8f0842719ac48d6c59b9489efb4add0710029ff68"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1ad5ef6643da1fbffe8232bae3f28900900af8ff8cb96b9a2f30977de9342bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a094ccdf847ed64592235e322121c29e42ea799094b9133551c893f466ac50a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d194306fde994dc2b3ee9c761bf4717f69c827fc24a41bf2fd0b49339e25b66"
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