class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https:oxc.rs"
  url "https:github.comoxc-projectoxcarchiverefstagsoxlint_v0.13.0.tar.gz"
  sha256 "7554f33a52582fcf0fc2e78fbea048bc718cbb481f8b2d0d82aaf8fe9b92edc7"
  license "MIT"
  head "https:github.comoxc-projectoxc.git", branch: "main"

  livecheck do
    url :stable
    regex(^oxlint[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9a919660075068f784af8657ea2a6d27b8b0382bb8c6c01c779e00dad71b5df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a78a2b0f5ed9a16ae074e2a0d823fe158aa418ee6fff8c06428b2f8e86f2ac2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "116a6b67a595c55dd3ddd0515c03061500700a6d980981e12336c23fb9b707a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "682bc3d976578f64db9920466acced8f2b7e7ceef77a3eb0191e1fb4bb99737e"
    sha256 cellar: :any_skip_relocation, ventura:       "541ba8aaaff8ebda5677e1f252333013dbe2cf1bbf286258421262305f616c2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "002d852a0c39bc000fdd45f697598b9cfa50b3314866152fe67ceaaa399a947a"
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