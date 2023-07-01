class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://ghproxy.com/https://github.com/elixir-lang/elixir/archive/v1.15.1.tar.gz"
  sha256 "cf89434f4cf7477b929c56e16ae22bf08e64101a144911d2834a2f3c9b3ae40f"
  license "Apache-2.0"
  head "https://github.com/elixir-lang/elixir.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2bc1530d48eb5280dbea280fbf5e0451391f2ce4a4b273ef50b5f671b6340e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66cc730eb6e4f2ce15a361ba0fd5aca2597faf2f1475fa8a771e07b5b1833a98"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "497003e6495e41248756e68cf2e60908256b421d0218701d576e121a5eef78bb"
    sha256 cellar: :any_skip_relocation, ventura:        "06476fc2d0a04d2a0892d27bfd52cf8ecba76481e5f24d4803f9193875e86a4c"
    sha256 cellar: :any_skip_relocation, monterey:       "c482552c0203f35f2975f3458dc5c9fa9451861e4f83e890a7d93fea0affdb5f"
    sha256 cellar: :any_skip_relocation, big_sur:        "519b5de3497e19340a3494e22052a3cfd45e77029f586b71bb7ee8616570d9f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b88ecddecc3b978fe49cc223acecc5ef9f3fbf6d203973db10cc72b1940c9f4"
  end

  depends_on "erlang"

  def install
    system "make"
    bin.install Dir["bin/*"] - Dir["bin/*.{bat,ps1}"]

    Dir.glob("lib/*/ebin") do |path|
      app = File.basename(File.dirname(path))
      (lib/app).install path
    end

    system "make", "install_man", "PREFIX=#{prefix}"
  end

  test do
    assert_match(%r{(compiled with Erlang/OTP 25)}, shell_output("#{bin}/elixir -v"))
  end
end