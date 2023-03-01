class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://ghproxy.com/https://github.com/gohugoio/hugo/archive/v0.110.0.tar.gz"
  sha256 "eeb137cefcea1a47ca27dc5f6573df29a8fe0b7f1ed0362faf7f73899e313770"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34dfa68bd7e40bd320910c2d04b7e580f5101823a80cd0bc123dd1a3b43b2aba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c72a226aa09e884b8b0e43137b4dbf40c425d2d7e992e52258bbf5c27fb3ab21"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "032796df5c3fc4094db3abd688b2986bab4c24761a4ce51f2dd0f8fea1962578"
    sha256 cellar: :any_skip_relocation, ventura:        "d25be6146bf704c535e9da6e4c15d0c375b77bbb3eda0b26501d1851d263bba0"
    sha256 cellar: :any_skip_relocation, monterey:       "abed3d5cd7e7357f22484a4a2e1087af8ec4309f4a9b694416b87c1a54995792"
    sha256 cellar: :any_skip_relocation, big_sur:        "e21fc8f2948dfd812ce9081551b294680568b17160618229fe5d6f1854b2386f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4cb16974713723501f6e6035da715621691f9afe6aa8cce902c408a205f5f2cd"
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