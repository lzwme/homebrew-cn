class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https:oxc.rs"
  url "https:github.comoxc-projectoxcarchiverefstagsoxlint_v0.15.5.tar.gz"
  sha256 "326640bf54e6e1f8dc6bb4195bb6a7c58995ce4f168b1371df9ffa9e53f87aef"
  license "MIT"
  head "https:github.comoxc-projectoxc.git", branch: "main"

  livecheck do
    url :stable
    regex(^oxlint[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37d66272500e3c1aecbd3de70a9162a7ed81f4d9494f6a66bb34eff0616cbe29"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "871608873e96047521cbbd2a84113202abc199349a5877089c980672e589edf0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6ebc4f88eb65dfd71875d4842e3e344700272a6adb1c9abb47016d434a86b686"
    sha256 cellar: :any_skip_relocation, sonoma:        "1513520c294d4e4bb176d93b06d850e129c283e05def2c425369a4c6acf8f119"
    sha256 cellar: :any_skip_relocation, ventura:       "68f538cd19f0953b90f940127667ea1a06c132e393cbf2ac10b29a3ebb736a82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "135015ce9c4bbb801a65a4a87ddd17793a147d4a073e6a066c2bddf1e3aa99b2"
  end

  depends_on "rust" => :build

  def install
    ENV["OXC_VERSION"] = version.to_s
    system "cargo", "install", *std_cargo_args(path: "appsoxlint")
  end

  test do
    (testpath"test.js").write "const x = 1;"
    output = shell_output("#{bin}oxlint test.js 2>&1")
    assert_match "eslint(no-unused-vars): Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}oxlint --version")
  end
end