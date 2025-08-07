class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://ghfast.top/https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.10.0.tar.gz"
  sha256 "e517be6c23a3f8da42f2584cbb6f732e3e9b9ec796e1de37e4535febce482d16"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f99b08c27aa9d4d77100c8c531a5c3da1d2ee52cf60fbb9ddb04c8e7ef353a96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "602a053302ff86848cde834400704b8e3d88124c9b94a2c69ddb8fba5c1b236e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "78e273e6626ab90f8ba8eb679b5b93a062d7c04cfa6c610047bb70a0180de27e"
    sha256 cellar: :any_skip_relocation, sonoma:        "4faa4a3e99522540a2508f3dc2abea768bf6be115e83d3809fba59a05c5f42e7"
    sha256 cellar: :any_skip_relocation, ventura:       "94016fa3e0aab711c09b27c96452b86889f6972bf94aa1724f6fbade52388582"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d81829a2c9ee10e83054ea15a7a51c1548d1e277a0732484faba62d4f5eaaee3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e1547cfc4d468b0099e31c90d9da3a9c8093add5eb0c24fa00acd246c5f5672"
  end

  depends_on "rust" => :build

  def install
    ENV["OXC_VERSION"] = version.to_s
    system "cargo", "install", *std_cargo_args(path: "apps/oxlint")
  end

  test do
    (testpath/"test.js").write "const x = 1;"
    output = shell_output("#{bin}/oxlint test.js 2>&1")
    assert_match "eslint(no-unused-vars): Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}/oxlint --version")
  end
end