class Oha < Formula
  desc "HTTP load generator, inspired by rakyllhey with tui animation"
  homepage "https:github.comhatoooha"
  url "https:github.comhatooohaarchiverefstagsv1.0.0.tar.gz"
  sha256 "56f96bc4e6a50d4e1b167f1f04d5d894197d10838d8e570b1b9868a3f9325114"
  license "MIT"
  head "https:github.comhatoooha.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "26f1561af57351ad1a4c4d0640f9a576b42e0677f07e832144e8c36423f02097"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "efe6101d1dfc98f3ae0a4c8cb926b61294fd9846d815a12dd6a3dc68f6eb1758"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46f1d20fa6e7de059aef7926f8d13156dea16f8c154b9f626820a0bcb2905eb8"
    sha256 cellar: :any_skip_relocation, sonoma:         "657bc14a7bc922b1770ae5fa78b1a6b041bf76c0a7c3317cadd26fe9feac1152"
    sha256 cellar: :any_skip_relocation, ventura:        "5a516c4d9def87c4fe9dfbdae71ad1d2d19128582bc7724f63239a5a5225d78d"
    sha256 cellar: :any_skip_relocation, monterey:       "e1368e0fc2cfee8c738ba053a44e976224722df47ff34c70e3736946ac4c6bfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8348a5e4d1eb391ea8e902f828a3d909e1ea47ae726365264a84e1c9a692159"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = "[200] 1 responses"
    assert_match output.to_s, shell_output("#{bin}oha -n 1 -c 1 --no-tui https:www.google.com")

    assert_match version.to_s, shell_output("#{bin}oha --version")
  end
end