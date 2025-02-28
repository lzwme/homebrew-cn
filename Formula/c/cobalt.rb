class Cobalt < Formula
  desc "Static site generator written in Rust"
  homepage "https:cobalt-org.github.io"
  url "https:github.comcobalt-orgcobalt.rsarchiverefstagsv0.19.7.tar.gz"
  sha256 "b714426bbb5ffcf24158f7a65ecb3e4c41e20ae45ff582625f71f9d6942d1b50"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91a4fbac2d54246b80651d3caff0d5dab80ab0bae75faf5528a76b7b5e6e303c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "301cc7529fbe73df00e2add0faa7beb987cc10fdda9bebd358ff1651bf641f8e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1e1ec83a215627e73ffa38ad4260c5fc47bf4417388c28243b96e37a1f506b5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "661b6ab0d611170d7b4abce568e431a7dd32c899eadee07f1831fc53f01a713c"
    sha256 cellar: :any_skip_relocation, ventura:       "1d44f5d01d85d643508db551d9ed6e99913a4c66b678a0d85186e421437eeae1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a65f7caba722fc05692c294f2699e33755fd59ccb72068060ff68d81ce589de0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin"cobalt", "init"
    system bin"cobalt", "build"
    assert_path_exists testpath"_siteindex.html"
  end
end