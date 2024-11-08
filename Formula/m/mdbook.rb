class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https:rust-lang.github.iomdBook"
  url "https:github.comrust-langmdBookarchiverefstagsv0.4.42.tar.gz"
  sha256 "cf1c7c293fd1ad3d51fe13cd385303df8b30004ba5edcc35dd8dbd23d670d528"
  license "MPL-2.0"
  head "https:github.comrust-langmdBook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e0042ec919503d740bbef64e4a6576cf8910f3ff1d1e7279e72296df6d0522f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b10ddc976febcbc71d6f4fe153b0130cf86cd47bdf765e82709eb08e3dbb0aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4d9171d3402c70ef01de58465aa333b0bddcabc6157afec46be46d0c54d48a4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "961b272865570522117852058d60ed97f2148706d0346ca89167acc8bb06da94"
    sha256 cellar: :any_skip_relocation, ventura:       "2c805980b1c7754ef2415714522651b437d56aba0359297c99ac013f2588c705"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8a2d07e99a976b6946065ce27d4fe0eb4140b6b88b411d438183d4b81fbfa20"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"mdbook", "completions")
  end

  test do
    # simulate user input to mdbook init
    system "sh", "-c", "printf \\n\\n | #{bin}mdbook init"
    system bin"mdbook", "build"
  end
end