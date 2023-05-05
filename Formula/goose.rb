class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://pressly.github.io/goose/"
  url "https://ghproxy.com/https://github.com/pressly/goose/archive/v3.11.0.tar.gz"
  sha256 "7e0cb6863db15c04d8b25d9414516314181a533f04152ec9e63c55d5bf65ca8a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "749e8a1737624a3f66b7cfb5553547988cc0413ca84eca741992fc0a7a8be7cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0cc6c43d34bcf9b01a55191c0bccfd4e1bb7ffd4f08ad9505195d8bb70fdf034"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b3ea7cfe6752e97365354fcec31f451ae699fc352157efb80c276ad188dd3f6"
    sha256 cellar: :any_skip_relocation, ventura:        "c4fdd09b7ccca3d788a9db5a7b474adeb5366ef21ffeb58e5bdd2afcf9c2b404"
    sha256 cellar: :any_skip_relocation, monterey:       "acc2d7707cb8a28be59b22f24edeebc5f470daf9b931e4680fc2dfde72aecd49"
    sha256 cellar: :any_skip_relocation, big_sur:        "0b136da93e30746ae9f48537942cb5b9ddc277772c92b16d5931377b9c5cb25d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f30fdb1d27961291e5798ea74d465d58772d3d56a901d772571c1a0bc5b8a7b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/goose"
  end

  test do
    output = shell_output("#{bin}/goose sqlite3 foo.db status create 2>&1")
    assert_match "Migration", output
    assert_predicate testpath/"foo.db", :exist?, "Failed to create foo.db!"
  end
end