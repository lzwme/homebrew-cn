class Lf < Formula
  desc "Terminal file manager"
  homepage "https://godoc.org/github.com/gokcehan/lf"
  url "https://ghproxy.com/https://github.com/gokcehan/lf/archive/r29.tar.gz"
  sha256 "82ec6e926941e1819aecaace32ed9a57597b714b5bbc5ff98dd519f1fa2239fa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04dcfcf8e53cbc5419af839397d3c5971b1a568218de7d441546bd853ddcc15e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04dcfcf8e53cbc5419af839397d3c5971b1a568218de7d441546bd853ddcc15e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "04dcfcf8e53cbc5419af839397d3c5971b1a568218de7d441546bd853ddcc15e"
    sha256 cellar: :any_skip_relocation, ventura:        "d6343878df5da2f4bc3954c45773debfdbfabe33876710e24b28999817085f84"
    sha256 cellar: :any_skip_relocation, monterey:       "d6343878df5da2f4bc3954c45773debfdbfabe33876710e24b28999817085f84"
    sha256 cellar: :any_skip_relocation, big_sur:        "d6343878df5da2f4bc3954c45773debfdbfabe33876710e24b28999817085f84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "075df08dfc399ffad0e976647dc5e5b78db586c50b3887dc59f956187feb1d10"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.gVersion=#{version}")
    man1.install "lf.1"
    zsh_completion.install "etc/lf.zsh" => "_lf"
    fish_completion.install "etc/lf.fish"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/lf -version").chomp
    assert_match "file manager", shell_output("#{bin}/lf -doc")
  end
end