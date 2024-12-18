class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https:oxc.rs"
  url "https:github.comoxc-projectoxcarchiverefstagsoxlint_v0.15.3.tar.gz"
  sha256 "5e7ee2c4293d090727b2a42cfe95c4acb1ec2cf60d568184ca535d795180b67a"
  license "MIT"
  head "https:github.comoxc-projectoxc.git", branch: "main"

  livecheck do
    url :stable
    regex(^oxlint[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01bee4bc8668d9dbb2e5018fe50d50515c7e66cdd53e1e8fed22b3ab82f0271d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f2438bb38be557df281f2ff9d8d91b2768dee911548dfca3db1c3f2ddfe5d23"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d0c8c5369784135cf177926699d32859888551e6c2dd9880b5f0b69149e4545d"
    sha256 cellar: :any_skip_relocation, sonoma:        "af1532b4d2d667fc25b79b09b6ecbae9e5a731b5e65c15e06d7c3b4ee07c2b4b"
    sha256 cellar: :any_skip_relocation, ventura:       "aad69c9c2c853381d59488175b67e8a95acf2223e5dfe22406ef6072e6de5f68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc83e37934d4c93e9f231ea67da1bb971146b016e2462508504186678cbd57e6"
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