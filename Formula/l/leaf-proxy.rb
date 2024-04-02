class LeafProxy < Formula
  desc "Lightweight and fast proxy utility"
  homepage "https:github.comeycorsicanleaf"
  url "https:github.comeycorsicanleafarchiverefstagsv0.10.10.tar.gz"
  sha256 "9d46c18e092090c3f73d42d6b61095ef862b4e5daee2a360d1708b7954157998"
  license "Apache-2.0"
  head "https:github.comeycorsicanleaf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a1299f9860bc8dd17852d5d1500773ed13810460af7370b26b8a98046c114cfd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "84d804b44982b6b568adab64f2310e6438accec8758701916c45caae5b944b85"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6fc81f74b64a2c96945047f281ceddaeaf9ec112cb310f61ea7a8aa3770069e9"
    sha256 cellar: :any_skip_relocation, sonoma:         "967bb3397634e2c3c533c755a30ba1abb4df07eeb5c4be2782c814f1799972d4"
    sha256 cellar: :any_skip_relocation, ventura:        "9d5ac683ebaff3cfd69baa1831b977a07c9dd7b75c5f9edfb0f51f829ee86174"
    sha256 cellar: :any_skip_relocation, monterey:       "ff7f69ac391a773cc3e403cff549bfd6c33f2ce98c16788ecc1dbc2f1defdfc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45940acec0378329bb743aa9816dd2f01f019d11a0d3bb74c060721b0170e462"
  end

  depends_on "rust" => :build

  conflicts_with "leaf", because: "both install a `leaf` binary"

  def install
    system "cargo", "install", *std_cargo_args(path: "leaf-bin")
  end

  test do
    (testpath"config.conf").write <<~EOS
      [General]
      dns-server = 8.8.8.8

      [Proxy]
      SS = ss, 127.0.0.1, #{free_port}, encrypt-method=chacha20-ietf-poly1305, password=123456
    EOS
    output = shell_output "#{bin}leaf -c #{testpath}config.conf -t SS"

    assert_match "TCP failed: all attempts failed", output
  end
end