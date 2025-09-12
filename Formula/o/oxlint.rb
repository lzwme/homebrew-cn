class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://ghfast.top/https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.15.0.tar.gz"
  sha256 "9822b1b1a2f3f70250d9a897d5fd63881d3abc54fdfb515999a349e63325665b"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4356f9cc5cd22e870c12fd3873167454166b36cb2093dde04f2da846d110e2ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e8231096ce49628eb71466244931c759d92a2585b58954b915d7d2e61115f45"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "337da9690da47d1c2dabe7cb1ae8af079bf052badad6791897f720524cb4b7df"
    sha256 cellar: :any_skip_relocation, sonoma:        "1867f3489b1166c1b815c6d146341349157e014fd7aa3a1b738a32a8db147998"
    sha256 cellar: :any_skip_relocation, ventura:       "b392c8b9b4326e27dd7b8a49a72f07179534e3fa8f714b0038513640a3bbdf34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5f770034dcd5b005fefc0db9cbf987f46aa3964252d7db406c990a4ab7f84f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d08e43eecd7b8e6d8ab8b0341dea1cc6d322974f6b247ccb768f710d3172ee55"
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