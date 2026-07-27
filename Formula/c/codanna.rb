class Codanna < Formula
  desc "Code intelligence system with semantic search"
  homepage "https://docs.codanna.sh/"
  url "https://ghfast.top/https://github.com/bartolli/codanna/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "81f8dbc9742c9f5e4821aa3a43281fbb60d235616b554e748273cca85aa321a4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "577b3566ea44062b4ba4cbaa9688fde73a86874156c7dece4f0bf8e3155f47a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18064f6e4c167610e0750edda2b6f05dce29b9f115048fe71a8909e2fb14962d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "facd8951835a92c58444f4ee8134a4e7f16f040019a5cdef836c5ceb9964840f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a696dfb91bc3d1d98479e22d50a9eefae19acf054373b5a46d072254822b9c11"
    sha256 cellar: :any,                 arm64_linux:   "828010c8e9c738b4ad6056212d11a6bd42f221898d6e3c0858c05be391e388f6"
    sha256 cellar: :any,                 x86_64_linux:  "7e8a693ece04430e7e490a564f8aa0c5bc1a172d3027b499f506517cbb4eb5d0"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args, "--all-features"
  end

  test do
    system bin/"codanna", "init"
    assert_path_exists testpath/".codanna"
  end
end