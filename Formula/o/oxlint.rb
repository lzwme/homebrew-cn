class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://ghfast.top/https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.13.0.tar.gz"
  sha256 "a1c75f4a5a40cc50bbb213e944b39990fb01e747fc61b6c778fd498376575afb"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d38428664536f765bdd828ec5e36937edbca8999a658d6b4c7e0398eb82d7a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a8b41c2ec1a8ed6ccf47d7296b3b1732d77e67a810f0e0cce9bf2913fd63e14"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3981cc70dda43a5b26b2423004649008427269d630437a22afc662d6bcc7e3e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "0761e4d18a66475afdb858969f368c520069a339fe46d9c0bad79a4493ab00fa"
    sha256 cellar: :any_skip_relocation, ventura:       "75e5138dc8a4eb0969a9071083c27a9afc61a8d66a8cd08d5e0d663c9186c1e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6639b13244dbcbb83ad786986eb8f46f74d940506a242fde0bbf39380d957b1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54c602a35b13e7939006b1a1cd5912f0ed5867ab062f1c8af1710654307a2a0e"
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