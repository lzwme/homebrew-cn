class Minify < Formula
  desc "Minifier for HTML, CSS, JS, JSON, SVG, and XML"
  homepage "https://go.tacodewolff.nl/minify"
  url "https://ghfast.top/https://github.com/tdewolff/minify/archive/refs/tags/v2.24.15.tar.gz"
  sha256 "37f8376c4f417ad601c106d82de52cf9fc6294da1f7a5284efee855390542a6a"
  license "MIT"
  head "https://github.com/tdewolff/minify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "785fafd2442fb068b3d00a01b41ebd08c446fd0b3957bd54fdf2c0bfd1b6809e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "785fafd2442fb068b3d00a01b41ebd08c446fd0b3957bd54fdf2c0bfd1b6809e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "785fafd2442fb068b3d00a01b41ebd08c446fd0b3957bd54fdf2c0bfd1b6809e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c555f11f107daae1c228d7ac8259de7641a23b5dc327458cdba1b76ded7ca1a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d1650a72961b851b29245e5bc960e7174c82606d09548788c719945919d8736"
    sha256 cellar: :any,                 x86_64_linux:  "8ad63bb95ab21bd34e8ecdeac7cd5352977f0bd472fb5954e0d9b349c12c97d2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}"), "./cmd/minify"
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