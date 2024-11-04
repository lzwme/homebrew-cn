class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https:oxc.rs"
  url "https:github.comoxc-projectoxcarchiverefstagsoxlint_v0.11.0.tar.gz"
  sha256 "bc339fd6e5dd34f1d005ebd4747d1186021ab41dc82b2eaba01404695a83d854"
  license "MIT"
  head "https:github.comoxc-projectoxc.git", branch: "main"

  livecheck do
    url :stable
    regex(^oxlint[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6b9873aee995e451ec162294bcaab53ca0d531a1119a1158ee9d7358c860de9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eda8780d2b69ba6aee661ed457eafbd8c9733c43e865aa51af506c2742b7cc26"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f3113bbec90fc3fb62d061a62f32a9226ce495ec5fc06bd9f0b3cecf5c517d42"
    sha256 cellar: :any_skip_relocation, sonoma:        "b16028e4cee8b5de24616f6db70b512166e969eb2200982bb33f68bc9dbba0b0"
    sha256 cellar: :any_skip_relocation, ventura:       "68346d0d73314f260176b24f70cae90c1cb3606950a577110eb504208be7c825"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab3061b1ad5d4706b43c74d580cc34067bdd5c5b491d64104aa815df439b55f8"
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