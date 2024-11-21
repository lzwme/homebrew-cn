class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https:oxc.rs"
  url "https:github.comoxc-projectoxcarchiverefstagsoxlint_v0.12.0.tar.gz"
  sha256 "16f4fea5a25527a41fa8b3bfb6ad7c8d28434ac75cef4ee635da46d18543620b"
  license "MIT"
  head "https:github.comoxc-projectoxc.git", branch: "main"

  livecheck do
    url :stable
    regex(^oxlint[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f762418822b019733b92216b51eb6d77777579a2cf7918d609086ac0f2de4af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a4f527d8ce8eadae2d053acbde01035820cd9f8429d3ca9dd0901cb8a1d6f37"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b99db9f4fa1b50c32dcc0654963fad667f66ff6f6ee91ad8082c527c44ea7aec"
    sha256 cellar: :any_skip_relocation, sonoma:        "61689585acf779e440ea965ee394d3106a628c8703da874bd6b43400af5e0841"
    sha256 cellar: :any_skip_relocation, ventura:       "ed696dfc7458675e381033eefea05858393ba69c22ddbb7fa28ab24bc3a2364b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4682765b29cc3486d3f422d72da4fa2e7f11cbf22625dd3245dfdf275fed764"
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