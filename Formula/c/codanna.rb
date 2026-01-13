class Codanna < Formula
  desc "Code intelligence system with semantic search"
  homepage "https://github.com/bartolli/codanna"
  url "https://ghfast.top/https://github.com/bartolli/codanna/archive/refs/tags/v0.9.11.tar.gz"
  sha256 "725f0156cbf036df5674aea794c4e508ee95d6c98500db8bb9f6561cbc630b88"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ccdb083c6d33296d950fa83759232d975c719f01df89ec42a5cca469033ea448"
    sha256 cellar: :any,                 arm64_sequoia: "13fecd271a5c0a6d3914602f017e666754b8a02972e32c6d82abb701693bc87e"
    sha256 cellar: :any,                 arm64_sonoma:  "ca3f729f9689d511392116e812e38044fccd46b53761d63803c88e8bc78227cd"
    sha256 cellar: :any,                 sonoma:        "26a7b20a47035f4d9fb27398495ee1325ad8d6cbb3efdf4c017902431322de5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98741692a4a5ccb9948762928ca3ec357f6d3cfcfd03ae32e91e071bea0f6fbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0aa56a33b8b7d17f97659e340297962b12529989f3bcbefa6493a90edb9e5787"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args, "--all-features"
  end

  test do
    system bin/"codanna", "init"
    assert_path_exists testpath/".codanna"
  end
end