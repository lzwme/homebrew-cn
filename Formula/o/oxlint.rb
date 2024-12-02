class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https:oxc.rs"
  url "https:github.comoxc-projectoxcarchiverefstagsoxlint_v0.14.0.tar.gz"
  sha256 "a28977286c74350c2f30a04e828c03a58860fb44a7c21cba5d0de8eb0c94ee48"
  license "MIT"
  head "https:github.comoxc-projectoxc.git", branch: "main"

  livecheck do
    url :stable
    regex(^oxlint[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "785a13611dc0fefa4a06b9724a26ba8358a9f3646506fbf161d4ab9f1f7ec7b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3381dbd081a9135809cb1765c2d6c384cb645e5b19bcfcd82f337297140e4beb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a172725577b09cf302ec5856b2500446a95cedd6e58ba05ebbd554854ef2bb00"
    sha256 cellar: :any_skip_relocation, sonoma:        "72933917d2c8d40acc433f0c1a815f0d35ac8e13479ca4d4600f63ca0de4d420"
    sha256 cellar: :any_skip_relocation, ventura:       "9f0050afacd6aaf699c4107e74eaa57fd31e38047959918dde326847c99d1c23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3299a3900a9f25ebd473d303f8c8cbc23d3e0c4b550ee411e87acfbd8088bdae"
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