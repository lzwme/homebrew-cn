class Rasusa < Formula
  desc "Randomly subsample sequencing reads or alignments"
  homepage "https://doi.org/10.21105/joss.03941"
  url "https://ghfast.top/https://github.com/mbhall88/rasusa/archive/refs/tags/2.2.0.tar.gz"
  sha256 "ffeae3f205c7628cbd5e747353ead0be4b5be924ddee89441ee20c2555b7feb1"
  license "MIT"
  head "https://github.com/mbhall88/rasusa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "471838b19cef389affb63f13c6b5b20ea08cafb25aaac474d6bfe3a506de62f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9aa0a7565facd581abac934e1b722d34d923b4acf99c52aedb0c4fb6e3cf2872"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a878b8b2a0dcefed3d18d018be6c27c8233b161f217be6e22eed145436b5025f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9568d26e22a7acfa3fd429baa60b3871aa540ad5696be0e335241cca501f7789"
    sha256 cellar: :any_skip_relocation, ventura:       "7d333d3d1f6da7aecbe93f7939de1585666196c81f7c60d2a20790ccfef81bae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0efb9dee380ecfdd73807bef63abb2e924c559e37291b6cc4788c7d72f19d0ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7a309163ae849811514baa1505c82317ccb6ed083eaa33d94f62aa8bd64b725"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang

  def install
    system "cargo", "install", *std_cargo_args
    pkgshare.install "tests/cases"
  end

  test do
    cp_r pkgshare/"cases/.", testpath
    system bin/"rasusa", "reads", "-n", "5m", "-o", "out.fq", "file1.fq.gz"
    assert_path_exists "out.fq"
  end
end