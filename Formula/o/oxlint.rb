class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https:oxc.rs"
  url "https:github.comoxc-projectoxcarchiverefstagsoxlint_v0.15.12.tar.gz"
  sha256 "d33f57d1a5dd3e04fd2e61e719a2745e30cb8db2b2e9af47f2211295d95f2612"
  license "MIT"
  head "https:github.comoxc-projectoxc.git", branch: "main"

  livecheck do
    url :stable
    regex(^oxlint[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a760f09da68e86a34ced14729ba3cf198375d4800414a4fde131910c6d218afd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fcbe2ae4c917f42a8233b0bfadce8ea5ba51aadb4498ff9217e2efd03b0e1889"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f799eb7466f1175ec65bae74942b77528cf3c4226e68308675730a2bdd6afbf8"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf76f87ff94cf72b2f1abeac02d553b4d96b8917d71d08870bcde641ea6542d7"
    sha256 cellar: :any_skip_relocation, ventura:       "077cd42e196351f8e0906368b89499b507fbe65749cb6d520c527582bc945d8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddb81eea10e5f59df1d0f9c3c7b148754328c01ebe567e24ffbe39e65ef22d71"
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