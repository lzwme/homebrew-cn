class Oxlint < Formula
  desc "High-performance linter for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://ghfast.top/https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.53.0.tar.gz"
  sha256 "db723793e706ada58cdc71609d237e5b7ebd9fa7bb2782ec5dbec26816b92bf2"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint_v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c05800acaa193a12c699f20cba6ea7554bc1d005de33069e8a4a19a8f2e3f959"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "848595a08a3037b45d1f6f6bdcddaeafede53dba8c08299a9e5ea2c8666b7e32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "473b7f398eb703c37c67f77a1ad3d28b0ca86bdb54a980f00c904be8983a7af8"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9572dc536eab4d62db6648a0e7f6e0f6ebf89d3e5272787707a477dc2322cbd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5ca86b17d9e0e826f5ba30e8e1df4913f450a475490e1a22856dab10d51bfc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c20f646ba73635139ecf435c9c000da29c0169064fbaa2160232a508e6471c55"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "apps/oxlint")
  end

  test do
    (testpath/"test.js").write "const x = 1;"
    output = shell_output("#{bin}/oxlint test.js 2>&1")
    assert_match "eslint(no-unused-vars)::Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}/oxlint --version")
  end
end