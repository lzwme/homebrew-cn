class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://ghfast.top/https://github.com/gohugoio/hugo/archive/refs/tags/v0.148.2.tar.gz"
  sha256 "562024495bb23ee54d11bbb63d15156213d40b24c5f5276bc8851dc6135b8602"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff5d6776b131957b3925e01d0bbbcb9ff2de85c565dd414ba3e2d371a800c141"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17ac22068b5e0f4749b99f91c1dbb9b61ab4cd4da232a95af203039c771cef27"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a74b633ae04f6f6a0217d8ee2f61fdaa096b78dcbcb9ce4f6cab1b895cea631f"
    sha256 cellar: :any_skip_relocation, sonoma:        "bbc081c665397bfb0c83d2606bcfe6482e81861b51ad5d1bb7c5f9919c1e47e9"
    sha256 cellar: :any_skip_relocation, ventura:       "7a7690a050b7eabfe76475f788af36bcb81b35aa1feae34d601edef37af94ed5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31b1a6f48f89301748c2846cdb8d74f564856c3435114b02025e1386f4387578"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7ccae13a23e06309412ae73d08410755f62fd11d2813d06d0c3cbfe38fd23a2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/gohugoio/hugo/common/hugo.commitHash=#{tap.user}
      -X github.com/gohugoio/hugo/common/hugo.buildDate=#{time.iso8601}
      -X github.com/gohugoio/hugo/common/hugo.vendorInfo=brew
    ]
    tags = %w[extended withdeploy]
    system "go", "build", *std_go_args(ldflags:, tags:)

    generate_completions_from_executable(bin/"hugo", "completion")
    system bin/"hugo", "gen", "man", "--dir", man1
  end

  test do
    site = testpath/"hops-yeast-malt-water"
    system bin/"hugo", "new", "site", site
    assert_path_exists site/"hugo.toml"

    assert_match version.to_s, shell_output(bin/"hugo version")
  end
end