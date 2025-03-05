class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https:oxc.rs"
  url "https:github.comoxc-projectoxcarchiverefstagsoxlint_v0.15.13.tar.gz"
  sha256 "c19bd576a03e155c7f22e777be0d9084916cfc182c1630636f2addcaa726b610"
  license "MIT"
  head "https:github.comoxc-projectoxc.git", branch: "main"

  livecheck do
    url :stable
    regex(^oxlint[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c50d486743df1dbd5c11bd0c4824ace0346a50fe86c65205b2bbd2fb5844cbdb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e0291d2186949a88e423ac1ed37ab15b6a53f1edb18202f30278e34daafdfee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c075dedb20413692541e1a8b32b33ccec458b5ce978bd6df349c3d43827b50df"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9a3ba7e35919884a6d5fba95127c1ee4db5076293896ff238ca3dd204b70df1"
    sha256 cellar: :any_skip_relocation, ventura:       "20f04a266e9035d8a72198511cb884bb2c9d2215c77416e6782cdb464e9d5b66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff3e9192dae5133c2e5a46163be05b6c65c3be83cdc457044d277e5eddb7dd95"
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