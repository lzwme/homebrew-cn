class Minify < Formula
  desc "Minifier for HTML, CSS, JS, JSON, SVG, and XML"
  homepage "https://go.tacodewolff.nl/minify"
  url "https://ghfast.top/https://github.com/tdewolff/minify/archive/refs/tags/v2.23.9.tar.gz"
  sha256 "a17d65638b33eedcd1707ae58bfeac727b8914b76f51df169dc3a19a65456012"
  license "MIT"
  head "https://github.com/tdewolff/minify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7698845488b83df22d0edf0a8ebf79de46234655ee144ade6b278628537cf7fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7698845488b83df22d0edf0a8ebf79de46234655ee144ade6b278628537cf7fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7698845488b83df22d0edf0a8ebf79de46234655ee144ade6b278628537cf7fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "9cbeba3c60de8b40a351827840282b552859022a8c1812b57a9adabdeda63b73"
    sha256 cellar: :any_skip_relocation, ventura:       "9cbeba3c60de8b40a351827840282b552859022a8c1812b57a9adabdeda63b73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43a113282d3adc256c2f78c667a0097663c563c5c4363f0dbc5a2081fd75b3b0"
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