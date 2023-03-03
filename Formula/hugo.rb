class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://ghproxy.com/https://github.com/gohugoio/hugo/archive/v0.111.1.tar.gz"
  sha256 "a71d4e1f49ca7156d3811c0b10957816b75ff2e01b35ef326e7af94dfa554ec0"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f8612e4107f8a42e478ed0a45921737c02b06e0e4189f814b2af287f70904c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a107aaa9997739aa290cdc0fb8b7faba179abaa2f4b34fc40015ca8b949eb22"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9d558ed964555a84af89c584451b85ba6f57dc53ffe029f7be191d880e13108"
    sha256 cellar: :any_skip_relocation, ventura:        "2248f8b40c3b57714ce3d6275ff26d223889199eb883a0adde598c661d96445f"
    sha256 cellar: :any_skip_relocation, monterey:       "6eeedb69be75c3d94cf678443e49c8d8120fc1557cc948123b40892a457438b0"
    sha256 cellar: :any_skip_relocation, big_sur:        "ff41fa6fe37316a51b7cb1445c96057654348cfd45f28e1e42a5771dcf62cf68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4951a17f3b7fb3556f05da4c6ff40fb0f5cf6c33c0e4dc7199b068145e9bc37c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-tags", "extended"

    generate_completions_from_executable(bin/"hugo", "completion")

    # Build man pages; target dir man/ is hardcoded :(
    (Pathname.pwd/"man").mkpath
    system bin/"hugo", "gen", "man"
    man1.install Dir["man/*.1"]
  end

  test do
    site = testpath/"hops-yeast-malt-water"
    system "#{bin}/hugo", "new", "site", site
    assert_predicate testpath/"#{site}/config.toml", :exist?
  end
end