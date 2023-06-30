class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://ghproxy.com/https://github.com/gohugoio/hugo/archive/v0.115.0.tar.gz"
  sha256 "da4b346c1ad9cb27c2348cf4933f491de5490d12d21ceac876017341b940d5a5"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ab414e14fa0440654139b32575636c4650f629bde7950422e13d77869135ea4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c2a9485374ad740c1161a4806b890c8dee73e61bb8e0d3baac1cf36227436b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ebee99eee57f23b961b089ed7c2b29ec2592899a0ce1bfb06383441c003b114c"
    sha256 cellar: :any_skip_relocation, ventura:        "577495195ecc8e28a4fb4e72f61f8e6d7c9a57e2ae711d169a8db805e7f6f9fb"
    sha256 cellar: :any_skip_relocation, monterey:       "e5dc739bd77c6760b990d25a5acdcc9aa042aba88ddec483d866f14ebbc8f44e"
    sha256 cellar: :any_skip_relocation, big_sur:        "782145612060242535ccbcede0fc9bc79b93948973b4e6ab7c0d65f0f939a084"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1599a89c7b37c8240fec544df0f7df29072661b743b24d9f5ade859a6b7ce767"
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
    system bin/"hugo", "new", "site", site
    assert_predicate site/"hugo.toml", :exist?

    assert_match version.to_s, shell_output(bin/"hugo version")
  end
end