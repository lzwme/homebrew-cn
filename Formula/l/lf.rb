class Lf < Formula
  desc "Terminal file manager"
  homepage "https://godoc.org/github.com/gokcehan/lf"
  url "https://ghfast.top/https://github.com/gokcehan/lf/archive/refs/tags/r36.tar.gz"
  sha256 "478be3cfae12322273985f443496a511b444ebbd5d5bbec05f7eddaa9b098968"
  license "MIT"
  head "https://github.com/gokcehan/lf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f21fbd28a05279721ee622d04e9f21daa7a1b7870e47dbabe293c2e88556fed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f21fbd28a05279721ee622d04e9f21daa7a1b7870e47dbabe293c2e88556fed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0f21fbd28a05279721ee622d04e9f21daa7a1b7870e47dbabe293c2e88556fed"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a7f38f3d9a1932a6c9934b340eff00dfc5f0839307cde99f7b663d4b6c78f7c"
    sha256 cellar: :any_skip_relocation, ventura:       "8a7f38f3d9a1932a6c9934b340eff00dfc5f0839307cde99f7b663d4b6c78f7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a18a64f717ec6dbc4cdf4615e0bdf0b6735e32ad9d439f596446faf1ec54836e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.gVersion=#{version}")

    man1.install "lf.1"
    bash_completion.install "etc/lf.bash" => "lf"
    fish_completion.install "etc/lf.fish"
    zsh_completion.install "etc/lf.zsh" => "_lf"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/lf -version").chomp
    assert_match "file manager", shell_output("#{bin}/lf -doc")
  end
end