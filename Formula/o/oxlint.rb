class Oxlint < Formula
  desc "High-performance linter for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://ghfast.top/https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.55.0.tar.gz"
  sha256 "85150c0e38c1c6a8e6a358932bb9aec43ee4af3fd7421bc4954b40bc237a89d3"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint_v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d4e13b1861f8bf2cbd5ddb7a2c93600dc43b0bf23c4f80835c72df54f858026"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "503d63cbee2595642c5124e6cc379d77c3d02eb99aedd006073e8f0e8fdc7632"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "817bcb1a65823958c8d59fa965c67b86dc1889e45ef1eb92396f4190748d029c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f3fac75a329272ebc284cba0047a7c91f4995e6a2f313a25ee6bf66bdea3f79"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5009e9978ddd2c82f20074ad92ba1d5accb1dc33b6c04f1f006c81c1197ec45c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b62e67c8479a5b946cef2f164052104f083bc60a48a6c4a974b804e2cfe8ca37"
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