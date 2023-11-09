class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdx/rtx"
  url "https://ghproxy.com/https://github.com/jdx/rtx/archive/refs/tags/v2023.11.1.tar.gz"
  sha256 "b6414078946e4c6c8a162fc7d604733c9c007616edf93e4219f4ea141e44363e"
  license "MIT"
  head "https://github.com/jdx/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "77c3dba8abeacd15dec781cb361a0f315034e2cb24b70a898a152ab5c67396f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "64ed26f49c1aa1e122e7c0f56c514ffefc41752762556d1a1bc3c2e523b2be85"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "472f00ea5f6a80340b35b107d1c4151d92dd20de6502d76752c97c1628b90c2f"
    sha256 cellar: :any_skip_relocation, sonoma:         "30d0a461d7752f609b0fb3df2c00975a04f7603da651481fff7c8a0093caf81f"
    sha256 cellar: :any_skip_relocation, ventura:        "a8cbfbea0c2f16db8a91d822abc45de41db94860ff590da45be05306a6a9e5f5"
    sha256 cellar: :any_skip_relocation, monterey:       "d5b16a38e7c4f2cff720431861b257b395079d4969ffe84a1d8ffea5c171fcf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e7c8509454d1aae68fcd1be5bc7a8f4cdaaccb218f3eced75ae944ee36d01f3"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", "--features=brew", *std_cargo_args
    man1.install "man/man1/rtx.1"
    generate_completions_from_executable(bin/"rtx", "completion")
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end