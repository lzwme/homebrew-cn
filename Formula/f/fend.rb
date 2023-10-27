class Fend < Formula
  desc "Arbitrary-precision unit-aware calculator"
  homepage "https://printfn.github.io/fend"
  url "https://ghproxy.com/https://github.com/printfn/fend/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "b0af31ef4d39d1c767fdb9fd1f998b555b5b435570e597795bdb3a29027de0b4"
  license "MIT"
  head "https://github.com/printfn/fend.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d40478e8fdd2406822a3aad5abb69b45826d0bb9193ddc4a5f7a58c43380df91"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e135f1f1e4f52c166d7f430ec044e94d8f1eea9935a1d2f08ba927bc44fae034"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1155ab0de5bea3557a762846cb99fd8bf38d1a6e531c663afdea7069a3cd1f28"
    sha256 cellar: :any_skip_relocation, sonoma:         "82993c66baa990ae85f36c504d13f5ebcbda570fdf97d6155ec4090563eaaf09"
    sha256 cellar: :any_skip_relocation, ventura:        "b53307df17300f52ba2c3ca0de7fc345ed028edaca08ba301aa16c03a096fad3"
    sha256 cellar: :any_skip_relocation, monterey:       "1366cfade8521770a59830a4d94f775d6b2df262ab1581c64054a2a3ea7039e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2953cdae0a2427b7093aa63e09cb456d598ee26bc3b0a1a95e17d7e6474cb1d4"
  end

  depends_on "pandoc" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    system "./documentation/build.sh"
    man1.install "documentation/fend.1"
  end

  test do
    assert_equal "1000 m", shell_output("#{bin}/fend 1 km to m").strip
  end
end