class Xh < Formula
  desc "Friendly and fast tool for sending HTTP requests"
  homepage "https://github.com/ducaale/xh"
  url "https://ghproxy.com/https://github.com/ducaale/xh/archive/refs/tags/v0.19.2.tar.gz"
  sha256 "5a54acc0a1f1c1ca2d009026cdfc3e01f3d173a77aafb1fd997dd3809fb705dc"
  license "MIT"
  head "https://github.com/ducaale/xh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "232805d498dd4e5bb65fe5d52432bb48c9424ce348dd9fc9e74eaa32b836d64c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7949e32426d2a876d5855c3be6f2df08f6fe42c1f40c7de8ed66b53b2282baae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd77f14d3c930b7b96f193c6ac20697628255463294b3ea974860f12c47153b2"
    sha256 cellar: :any_skip_relocation, sonoma:         "132a3b40cb4af58ba134bee93326ca5dbd9dd09923fbde423a0b9252618df980"
    sha256 cellar: :any_skip_relocation, ventura:        "3cb7b2858365b7aa761136fcc88acf2c2c5fa013b827a358650942a23c7f33e5"
    sha256 cellar: :any_skip_relocation, monterey:       "082237b93996621eb0b70d264baac1cfc66d1ffbd6e29facbbe747ca57b68d44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3d0172d4b5c61545fda04b8251b369286e1ba5a362c659756464691b4868f79"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    bin.install_symlink bin/"xh" => "xhs"

    man1.install "doc/xh.1"
    bash_completion.install "completions/xh.bash"
    fish_completion.install "completions/xh.fish"
    zsh_completion.install "completions/_xh"
  end

  test do
    hash = JSON.parse(shell_output("#{bin}/xh -I -f POST https://httpbin.org/post foo=bar"))
    assert_equal hash["form"]["foo"], "bar"
  end
end