class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://ghproxy.com/https://github.com/gohugoio/hugo/archive/v0.115.3.tar.gz"
  sha256 "1c6b089306c22325f3b2a43c69ba878d63c3ca472f07365c99adc1b0e45624d9"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b89de0c6be5884fb857b089af3d7b1a63e4e2c2c6a8278286a5b97fc382aa6d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39b348b51a303fa50261e42e4e302843f1c741ffe169a84d82bfd720acb5f9ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e7ec3a12deb949a6c4ecac84673203d173bb83813263c745b4cc73dac477e9b6"
    sha256 cellar: :any_skip_relocation, ventura:        "70cec72ea465d1374b0d69d9d7e65b00796c26bb55e6ec63a3d0da9b08996621"
    sha256 cellar: :any_skip_relocation, monterey:       "a76807fddc6a27368a3492ac471860883a56e3e5b4410bbc67c27219994e42a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "5ba0ce79d0b1daf6222156748af0f158884d4488416667a4b57cb31b132d13ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39bb7c845650c34512569c0dd64c701287bcbfa7d029fdbdf716bbde39f35738"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-tags", "extended"

    generate_completions_from_executable(bin/"hugo", "completion")
    system bin/"hugo", "gen", "man", "--dir", man1
  end

  test do
    site = testpath/"hops-yeast-malt-water"
    system bin/"hugo", "new", "site", site
    assert_predicate site/"hugo.toml", :exist?

    assert_match version.to_s, shell_output(bin/"hugo version")
  end
end