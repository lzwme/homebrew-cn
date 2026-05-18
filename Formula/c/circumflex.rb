class Circumflex < Formula
  desc "Hacker News in your terminal"
  homepage "https://github.com/bensadeh/circumflex"
  url "https://ghfast.top/https://github.com/bensadeh/circumflex/archive/refs/tags/4.1.1.tar.gz"
  sha256 "c5900e13c41d2e5a1da2d45e0d63b38d345dca584edfbf8e60b4daa7cda88cae"
  license "MIT"
  head "https://github.com/bensadeh/circumflex.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "950e2d99874688e36c1b0950dacbca36068b0d22a8b2be58fa49761de5461b70"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "950e2d99874688e36c1b0950dacbca36068b0d22a8b2be58fa49761de5461b70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "950e2d99874688e36c1b0950dacbca36068b0d22a8b2be58fa49761de5461b70"
    sha256 cellar: :any_skip_relocation, sonoma:        "a34efb5434e33d6f180906091ffbf36f6d8ae97f5f3ec5ea23b31797f96f4fe6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "110ac9e04a50ca218c7590a158608d23babc29001f90a942d568183e1a613280"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9045e704896543669129c725e4aae147a51e49b516126ce7960163164f8b670d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"clx", ldflags: "-s -w"), "./cmd/clx"
    man1.install "share/man/clx.1"
    bash_completion.install "share/completions/clx.bash" => "clx"
    zsh_completion.install  "share/completions/_clx"     => "_clx"
    fish_completion.install "share/completions/clx.fish"
  end

  test do
    ENV["XDG_CONFIG_HOME"] = testpath/".config"
    config_home = testpath/".config"

    assert_match "Item added to favorites", shell_output("#{bin}/clx add 1")
    assert_path_exists config_home/"circumflex/favorites.json"
  end
end