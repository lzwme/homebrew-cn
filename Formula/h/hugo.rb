class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://ghfast.top/https://github.com/gohugoio/hugo/archive/refs/tags/v0.149.0.tar.gz"
  sha256 "2e8058ea2cf66b4935c8f4269fcc728efe4106f8bff034c0bd092f8cb4d607bb"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1e31956664027d6d13c51c0544fc2720c6581710e6f23ea8df412d8ba62c6f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3cfb538b02db3b00ff784dc2aeb3477c9935d802491c2d8ffc65a6aa20dc52d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "66929e6322c3e6811822b8f5b6f89be7592a39a0bec41b2d5374009bdf9da48d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3d978041a4d2668d2d215b580cea7ce14ca681c245a0d486139ceb13a98dc62"
    sha256 cellar: :any_skip_relocation, ventura:       "b5cde0ab8a9f8b1c25fa3710734b8553a17797d81d53a9bf8153bb7584aecc2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f09e9c7289ca6e6286a34b5c22b5d1b81ee24dfc30347d557f1f27f1aa0e8ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a34c08eaa0600a7f952b97a860db97eb4c025fa46572636f27982f71954abf78"
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

    assert_match version.to_s, shell_output("#{bin}/hugo version")
  end
end