class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https:oxc.rs"
  url "https:github.comoxc-projectoxcarchiverefstagsoxlint_v0.16.10.tar.gz"
  sha256 "f2f2f56ab75eeddd0dd129db0b1c816022c0121e80a1f2c0aaaf768abd08f99d"
  license "MIT"
  head "https:github.comoxc-projectoxc.git", branch: "main"

  livecheck do
    url :stable
    regex(^oxlint[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "010fb93348b0dddd0d84418ef0b6987048980a2b5df1fd13344e07aad76c8b7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30795ee01f3a0d51c62857101f7808a9243e68fd90a0a2b6c007d94c5ce3e131"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "52e2efe941dc85db6d37054f5fe10b06a30683dbc3e2977a486a286e2067087d"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e98cb8c5cd7f91432e1db4b0faecf89d2678e821b9f039ccef98c044bebbb27"
    sha256 cellar: :any_skip_relocation, ventura:       "3d6bc8145e6087226413560833f7c5577fc0a04edd9afc3583bb80e9a84a8b33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d5ff0303477c5ef9a1f9d3a95eb9da9222e63c6be6db543b39adfefe53b779c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c551e1084c2847e2a4cd225073b94338d24626c0ec24dc3f3db6847402a21d9d"
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