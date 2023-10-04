class Tbls < Formula
  desc "CI-Friendly tool for document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://ghproxy.com/https://github.com/k1LoW/tbls/archive/refs/tags/v1.69.2.tar.gz"
  sha256 "f3a4f3aab5b07afa5b30166cc5020b547576a9d119ea93d7172c0357510464cb"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9a4cfe0104f251e1c5e1bf23b88b414cad2929ded2246c8fa3cc9fda01194eab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d2278f756bc4c0ce4cee0d39a8bbe1770d34cf9579afb5129fd7e1f9dc8a831"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0f25bc999baa3f859fc1b10a7b21ebea6cb7f903fde00f5327bf55d930b3d95"
    sha256 cellar: :any_skip_relocation, sonoma:         "c35f6165d719d579072c2f0e3bcf03863f2050f9f6eb103a56d27f6fcf5527b5"
    sha256 cellar: :any_skip_relocation, ventura:        "1a6220b49939af61d847241e85a5b3cf3cca65a4bc5b016ab57a6e05e7770ae8"
    sha256 cellar: :any_skip_relocation, monterey:       "4d3ab0a44c6894ef823493fa158dbd05efc76d965161428cf52073da0594b410"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e0ff189fee6784a63e17c24eecc2f915f2be5b45f551cae9a25f143372ac934"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/k1LoW/tbls.version=#{version}
      -X github.com/k1LoW/tbls.date=#{time.iso8601}
      -X github.com/k1LoW/tbls/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"tbls", "completion")
  end

  test do
    assert_match "invalid database scheme", shell_output(bin/"tbls doc", 1)
    assert_match version.to_s, shell_output(bin/"tbls version")
  end
end