class Codanna < Formula
  desc "Code intelligence system with semantic search"
  homepage "https://github.com/bartolli/codanna"
  url "https://ghfast.top/https://github.com/bartolli/codanna/archive/refs/tags/v0.9.18.tar.gz"
  sha256 "8d5198cebaeb2b7a6a48c09872435bbf87c1a737d6e2d383f5c0521efe657fdd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "708715527007b42257580fc05b4493ca153656fad4550e6fc742094181e699df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69fdce361f7d6cec0a24585cb962105597919242feb5d875add7ca21011f7b82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b001c182b19c6b95506a85fdb97e6c4a1f165a070e5b71cb2be6708c30b9b5ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "049e1fe60ac58afa16038768e58bcb891021c57e85b91098e5539579465b053a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f939b20156d1d1ffb9f06461d44904aeb359c0f9d4de96497399c339ad5ded0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79d614b58210574222745680fb665d6640d7ce55c7d8f3a95f3be4d32f9be9ce"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args, "--all-features"
  end

  test do
    system bin/"codanna", "init"
    assert_path_exists testpath/".codanna"
  end
end