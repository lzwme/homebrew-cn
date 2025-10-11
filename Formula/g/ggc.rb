class Ggc < Formula
  desc "Modern Git CLI"
  homepage "https://github.com/bmf-san/ggc"
  url "https://ghfast.top/https://github.com/bmf-san/ggc/archive/refs/tags/v7.0.2.tar.gz"
  sha256 "ab7bb474e99cd108fbade595be43375da4afad52c74b3d53ae58d1340cc3d7a4"
  license "MIT"
  head "https://github.com/bmf-san/ggc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de0f37a8c6b80d35a7b84406358f1ae9b96cc6861dcc82e4ca19baf6ca79f2cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de0f37a8c6b80d35a7b84406358f1ae9b96cc6861dcc82e4ca19baf6ca79f2cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de0f37a8c6b80d35a7b84406358f1ae9b96cc6861dcc82e4ca19baf6ca79f2cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "51a94b529798f301f26474c2654e8b20570b6403e26142612923aeff7b9778d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49713fbdfaf46ae5d904c3c939cd639d5f2cad4bdeb911d6782b1708921aa724"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ce57b8ad3c19041bfafdfef0c057445d643c11047c56e31565184c4960101e5"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ggc version")

    # `vim` not found in `PATH`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_equal "main", shell_output("#{bin}/ggc config get default.branch").chomp
  end
end