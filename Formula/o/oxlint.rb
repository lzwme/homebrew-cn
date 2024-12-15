class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https:oxc.rs"
  url "https:github.comoxc-projectoxcarchiverefstagsoxlint_v0.15.2.tar.gz"
  sha256 "e5339110594b1d1cd300517e8b4d6a1adabb3bd0a47bd4516468370198803ee4"
  license "MIT"
  head "https:github.comoxc-projectoxc.git", branch: "main"

  livecheck do
    url :stable
    regex(^oxlint[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06b741f281af4e40f4d45d4718ca14df5551eaa1ff5d2fe2c5ad3e0c16e63ba4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e03f61379dbe6f5a5a2ac22f75acc19d3fbdcdf0f2b844d33041345b5d4ac883"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a15573ce556206dce634a101e3dc29845af9b5cb71f250abea176c1fe632b611"
    sha256 cellar: :any_skip_relocation, sonoma:        "f34c991ced0443a7e6fe3550b3fe90d3f4bafcc97115beecf59bf3352b6c2b4c"
    sha256 cellar: :any_skip_relocation, ventura:       "0a1197b825e404abd8af28840261f621386cc4eff4917667206530b6ef6c9b70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc6094fd90bf325883ebd434e3b7b53e996cbd290378e4c7c6d68feb952e68af"
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