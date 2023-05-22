class PipeRename < Formula
  desc "Rename your files using your favorite text editor"
  homepage "https://github.com/marcusbuffett/pipe-rename"
  url "https://crates.io/api/v1/crates/pipe-rename/1.6.3/download"
  sha256 "7f69604f7a1f7fa9914aeef8491ee2281b8b1e3fab2eaf4f63c1e5d57e37d654"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "10c8e43b8b7d9ad71e4450de200eb02ae23ea9fcb6a0eea28ee939ad07e7dac7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b12b2d562a01f199bab5d515f7ee8535e47f8054020b9b5cc7b84edf17e4fe90"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bf587e6b163e2aefd5a744bd1b632b712e17c98b8756f6708a187850832e716b"
    sha256 cellar: :any_skip_relocation, ventura:        "6a5f6da5275171b73fdff4e84c894c5b09b25c93fa43c16d68a2ccb6de3979cb"
    sha256 cellar: :any_skip_relocation, monterey:       "a01d683ed501ef6f8f90b3519a2d514307f653ba7ce5bd715f5d45c66dc59bda"
    sha256 cellar: :any_skip_relocation, big_sur:        "7cfe832170c549b9127fd8cd0cf86951735e205c32d6691df60d07db2e1381a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "280d57691871f7bf4c42fd8d9abf6fb23aa58d0b459a3d051545a74edee2a971"
  end

  depends_on "rust" => :build

  def install
    system "tar", "xvf", "pipe-rename-#{version}.crate", "--strip-components=1"
    system "cargo", "install", *std_cargo_args
  end

  test do
    touch "test.log"
    (testpath/"rename.sh").write "#!/bin/sh\necho \"$(cat \"$1\").txt\" > \"$1\""
    chmod "+x", testpath/"rename.sh"
    ENV["EDITOR"] = testpath/"rename.sh"
    system "#{bin}/renamer", "-y", "test.log"
    assert_predicate testpath/"test.log.txt", :exist?
  end
end