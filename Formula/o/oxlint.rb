class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://ghfast.top/https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.7.0.tar.gz"
  sha256 "3d8e3be7c10898bca1a1a98569ea77a8fd06b1c4ff517118a9f4a1fe1fc69f19"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "875d075fe4f3d1cde520ad08ee25464cdef78d998ce710c929b0dfebfcc194b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e530b09185dfb8858214f10ddc3a357ed61cbfdc20345b1d08b17811bd0f93b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6d4a92a80605cd986ffd10667b4ce713a95b753c313e6e1a46c619119ed36044"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5efea049370c1359e6d7894477683206598705c54009996aaff7b2c4b9cb330"
    sha256 cellar: :any_skip_relocation, ventura:       "b30fb530f0ef74409ce318882771e78f3e35f47029b2242b41d430321a2da90e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75c5aeee15c2828edca346c8431a7852e726a1b09a7d3f59b3cd0e53108998c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bbfcc809ce9f4d40f4e1a08e6abbee120ebef76dc1f40122f2c594d337df2ff"
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