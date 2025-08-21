class Minify < Formula
  desc "Minifier for HTML, CSS, JS, JSON, SVG, and XML"
  homepage "https://go.tacodewolff.nl/minify"
  url "https://ghfast.top/https://github.com/tdewolff/minify/archive/refs/tags/v2.24.0.tar.gz"
  sha256 "618392697d8b0c0a994054b97ccb8dbdee067b87258644ee346eff83d8e85dc5"
  license "MIT"
  head "https://github.com/tdewolff/minify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54e83b371cc92047eb862df45c173199fa5b7526010e571175ce6156503f2b10"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54e83b371cc92047eb862df45c173199fa5b7526010e571175ce6156503f2b10"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "54e83b371cc92047eb862df45c173199fa5b7526010e571175ce6156503f2b10"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f0e7773f4faf23b98e4e8da13e70c84647f7948d2f0c75553bb9195627f74d0"
    sha256 cellar: :any_skip_relocation, ventura:       "3f0e7773f4faf23b98e4e8da13e70c84647f7948d2f0c75553bb9195627f74d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "799179f0381df0d4d5ebf728bf8b5079076817fd61da799abd2e836b7efb061f"
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