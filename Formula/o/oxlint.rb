class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https:oxc.rs"
  url "https:github.comoxc-projectoxcarchiverefstagsoxlint_v1.3.0.tar.gz"
  sha256 "660fffae9e46724e5dab8dbb13fbe50becef537057790dcd659f85727dbaa823"
  license "MIT"
  head "https:github.comoxc-projectoxc.git", branch: "main"

  livecheck do
    url :stable
    regex(^oxlint[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7674697d7bebe28b8be2204eb32587d97f6da8be0cf15d9197c78d4e3b47c520"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7eb52ba7ad2a798ed8a0f594c937c08f22f00d1036e19b793a552237239c52c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a794c0b06beb7de35df729f78e7b8f41fa067bfd3888968090568e6e0082da6c"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5d15f9e9b28510d034ed8b6ac6777051b3940ab6fb1dcdd8e043ac0e82454ee"
    sha256 cellar: :any_skip_relocation, ventura:       "d9d5cfa20ec071509044592a6a683d26af9a962fd69dbe556cc59518f7d143c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8286e58843e98a8576650b1b0ef541c2eac6d7d67ce637c2a0af1efb0c693297"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "859234fcbced88031760d367bd44e3d0bd16c2730ee86382ae6aa96ddc621495"
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