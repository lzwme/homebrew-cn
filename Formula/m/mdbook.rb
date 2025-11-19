class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang.github.io/mdBook/"
  url "https://ghfast.top/https://github.com/rust-lang/mdBook/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "0d092a75ad1950e80f5f26529ebc10af25f8a795222224d72d9b99f259065575"
  license "MPL-2.0"
  head "https://github.com/rust-lang/mdBook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9920020f15349aa2c51dca1df2d8bfc0437e10c0471f8d14e8bc15b86f2d259"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c61983adcf2884a2590e66f2aa6180f4a79de585e89eb8554d4f30f14c8ecfe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be5ac5a46c17678b2e4b9ec5d319c8874ccaa736dfe56d01aebe921e111900b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "14846d9162d2ebdbc1611e5229097efb77ed7325fe76e10ef163b2249c3e3077"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e02e556af28702b6ab9e885192a16c3b05abdc5e01bd28feffcb02acf2898f51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ad3ff86445028e3bd3a60ac7e434ddf8528825bb60337e99ac1a9f83fd033d6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"mdbook", "completions")
  end

  test do
    # simulate user input to mdbook init
    system "sh", "-c", "printf \\n\\n | #{bin}/mdbook init"
    system bin/"mdbook", "build"
  end
end