class Cbindgen < Formula
  desc "Project for generating C bindings from Rust code"
  homepage "https://github.com/mozilla/cbindgen"
  url "https://ghproxy.com/https://github.com/mozilla/cbindgen/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "363ac6317a5788de8f2b0104a472a747883d4b9126fa119c681879509dbdbc28"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "52f6ca3f265b412a45ffcd347b0e83a75c9240d0b6c020e6d7d0f1ee5a885860"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5625fbed66548ef4f47c8a8f8f5a9a49d595d17f4e003f2f21c5a7977d30b46"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8dd82203938f8c0de71a92d2e2c307aa2fb7ee7e52104604699b2fb56693e6e0"
    sha256 cellar: :any_skip_relocation, ventura:        "d1a093a826fc849723adf20bc4c760dcf6bc6718669deedbaa0c4123c6f95664"
    sha256 cellar: :any_skip_relocation, monterey:       "ed58dbee111023014d8d8795f75f89af10cfaad2cb78dfadaccfc8d1eca8da59"
    sha256 cellar: :any_skip_relocation, big_sur:        "19fd5fc0335e35af6d8bd803844ec862da4833158bcac821c435db3d186bf8db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c3c7735570a4f6d9c7d04ffb4a729436a9ed817f5a78cf085f888caa9f6652b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    pkgshare.install "tests"
  end

  test do
    cp pkgshare/"tests/rust/extern.rs", testpath
    output = shell_output("#{bin}/cbindgen extern.rs")
    assert_match "extern int32_t foo()", output
  end
end