class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://ghproxy.com/https://github.com/gohugoio/hugo/archive/v0.112.4.tar.gz"
  sha256 "3e5127df4940690e26fd6aec23bb4bc99acc272d7f3d194ccdfa20f665be82e8"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "125fb33d06a54b3881c56eb13e3bea16944f68af8a360087f407cf27a562c2fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64ed5f5afc15fc238844ba1b18d2a1fa83b36092475d8ce259b751ec32f9912e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d2fa6d2d2774ba71a9a28ecc784973157b8b6d282a709675e2c9bc656c38f55"
    sha256 cellar: :any_skip_relocation, ventura:        "b1ddddc93bb68d1b363de507b69f5f675366abf097cba484ffbd7386adfbdf67"
    sha256 cellar: :any_skip_relocation, monterey:       "0c7de0767e277cac168cbf4dcf3d65db26d00fc9c620aff475bef6a16f01a01d"
    sha256 cellar: :any_skip_relocation, big_sur:        "9aa3223e2fe5d84329d238f981170a72a8f1a02191c7bbcbe3724bd1997b7ab7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53601fa1e72cd53d05c8b682e8288ee75acc799bacc0051db06ea5999585118a"
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