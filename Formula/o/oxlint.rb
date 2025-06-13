class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https:oxc.rs"
  url "https:github.comoxc-projectoxcarchiverefstagsoxlint_v1.1.0.tar.gz"
  sha256 "bee1221b1a03ac20cb7225defd4c513645e58d375133542bf5349ee393931cb8"
  license "MIT"
  head "https:github.comoxc-projectoxc.git", branch: "main"

  livecheck do
    url :stable
    regex(^oxlint[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4dc6f91e8c96ad5058714b7cf802bd88d3d3442bb071466f6dbf7728001e992"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69ca54f7eb3c9e5dbf2962504483b6c388069ef1974489a9190fff284182a7e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "297b62f17cfa4fd881c52409d4b57fb049c53d3b418862e68c1348f2b73bbc17"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb0a53d02e19f8edadbd577fe4dcc2edeaa10ad89422b82e4e04b1d58c5dc473"
    sha256 cellar: :any_skip_relocation, ventura:       "a0f5db2ae9f7e264e82095e3bdf8cdaa353b0f7c01566f242aff78bd043a8cce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59f2b401b276ef5c5ba756c8f057e01c50ad02bbc1f9e29aab5895aaf72e1d91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75d65ba9816e3e658b4d8666bdbd6944a5ba1cd30770a4682ee1df48144b1a12"
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