class Tbls < Formula
  desc "CI-Friendly tool for document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://ghproxy.com/https://github.com/k1LoW/tbls/archive/refs/tags/v1.64.0.tar.gz"
  sha256 "1d4668628c5ed97ae2d3da72bcd1cc64c4003562ab596bfc54772c4e9787841e"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19c5ad025ac86922df5807f2410363f6e69539007bb4dd729fe103450cdcc6cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cbcefa984961336125cb08e6450bb9b6538e77cf62437bf8822186fbe0f81e8c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f6bb357f8e95a2441991d4d6c911a75ecc02e97edaa4dc726017d9c204095ee7"
    sha256 cellar: :any_skip_relocation, ventura:        "31127979efaec772dab3f3c2c78531b8ab569d3e29b071956b699ca5b496f959"
    sha256 cellar: :any_skip_relocation, monterey:       "ee1dc0bc533f1e1c03b768eba1eea5b959e6fadb7a94ad13a0e10cd02e81e563"
    sha256 cellar: :any_skip_relocation, big_sur:        "9881ad12aa6dce0403babed520ec480ca226083dfdfe53f0e939cf13e3efc7d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45211ed164478bf03ccd3ad2dd5953b19c49bbb01d29391ed9276efb4a1d386f"
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