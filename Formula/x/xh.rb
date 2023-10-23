class Xh < Formula
  desc "Friendly and fast tool for sending HTTP requests"
  homepage "https://github.com/ducaale/xh"
  url "https://ghproxy.com/https://github.com/ducaale/xh/archive/refs/tags/v0.19.4.tar.gz"
  sha256 "1ab3ede256d4f0fba965ad15c0446a48ff61524ef27d3a1067916b1359568778"
  license "MIT"
  head "https://github.com/ducaale/xh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "149c29c4bd3f02e3d73a1f1ab8ef118508d7923ebf6b86f7539e5d3612a3859e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76e40cc8c056a10f5c171352997ed36dda79d5f4a55edd1b8f6eec1dc1bd0484"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9fdde7e3cfc70b027d16f474aa52829b1a0757a898ab798a0e471b10f22bd57d"
    sha256 cellar: :any_skip_relocation, sonoma:         "3ff009f622cbcd53c5d334dd02c5e34af0f2e2a98e379437dfdcc1b90147a180"
    sha256 cellar: :any_skip_relocation, ventura:        "0920a2aa393a0ce8491cb1fd3879b66a2432b93a23ae51ca22b6502b6933bc7c"
    sha256 cellar: :any_skip_relocation, monterey:       "f8d28ce7ec69fd3f89e4aa95b0ac00231f3638f3acb06d54ca7ebeb0c035539b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d81a8fd637f255a72943a49cc8e4bd9b29431bc705a62f4970daea0ce5e069c"
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