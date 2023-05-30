class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://ghproxy.com/https://github.com/gohugoio/hugo/archive/v0.112.5.tar.gz"
  sha256 "27babc901a50c4d650355a7507d438d1772a75393d99951fd59ef6d7be5c8b0e"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf6a81aa4065018ffedc5a89837976221f23f6aa536073d202fddaacded1ef10"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f90b625e55e8c055b2b9abc53178c1e90540f54f34e27a1217d5a834fc435c15"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1cc0bb60ca530b1c1f313da37aa14af7e5e961fe72434d9d1a78dd47eca364ce"
    sha256 cellar: :any_skip_relocation, ventura:        "efbad46dbd41a4feaf66507dfac3c9bb9f1f3860a034dde9bfb70909275ab5a6"
    sha256 cellar: :any_skip_relocation, monterey:       "578506534a300549c29945fbcd46a7051330e4e3bf7b6b47394ec906f805541f"
    sha256 cellar: :any_skip_relocation, big_sur:        "e6dd539fc8d999a63bff1262297842f7c3bc5209e0def4aa20aaf02ebe53fc94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "117466a41a660dd3e36c4e05076ddeba001060848351721f787aac0b1ef89b89"
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