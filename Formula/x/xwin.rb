class Xwin < Formula
  desc "Microsoft CRT and Windows SDK headers and libraries loader"
  homepage "https://github.com/Jake-Shadle/xwin"
  url "https://ghproxy.com/https://github.com/Jake-Shadle/xwin/archive/refs/tags/0.4.0.tar.gz"
  sha256 "3b032935940d9cff2ad5217687e3e359a7ca6746c13b9203af25330467f32976"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4105c144f1b9d105b6a5c6571f0a229edb2c70cce7f0c0f220a5b7798da0e9d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "63cd718771ad7159f9faf731a45ce56d65cc76fdf55d6e9f7f29b964e1236932"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9dcbe2f86389bb4c9eb4a3f114b0880f2a54159dcc681ea0ceff92c5e9b00d03"
    sha256 cellar: :any_skip_relocation, sonoma:         "5984d11087b367982199d6deebb206f239521aab9566734cd0bdb5f69259aa9a"
    sha256 cellar: :any_skip_relocation, ventura:        "e376a2c0d7934ab4e0b7dbd6c0da1aacb2c28f8a607af0f764ecb6805ac007b7"
    sha256 cellar: :any_skip_relocation, monterey:       "38a6a1d03d316903afb84a658454c614875d6e806a61cb7876d486ef2cf17641"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "304185b5a08d7db275068bc621475b7c544922952f8828bcec16a804a352650d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"xwin", "--accept-license", "splat", "--disable-symlinks"
    assert_predicate testpath/".xwin-cache/splat", :exist?
  end
end