class Ggc < Formula
  desc "Modern Git CLI"
  homepage "https://github.com/bmf-san/ggc"
  url "https://ghfast.top/https://github.com/bmf-san/ggc/archive/refs/tags/v8.6.3.tar.gz"
  sha256 "58276e4e07f204aada8b67597701904c103257c844a1f32258f3a50a2075f9e2"
  license "MIT"
  head "https://github.com/bmf-san/ggc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe1d3e036bbfc4a09b5d636d7c88ce73d62d38a29fc3f394e664bfe69af79e78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe1d3e036bbfc4a09b5d636d7c88ce73d62d38a29fc3f394e664bfe69af79e78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe1d3e036bbfc4a09b5d636d7c88ce73d62d38a29fc3f394e664bfe69af79e78"
    sha256 cellar: :any_skip_relocation, sonoma:        "a26c1346750927716c30aba89b7f8232278b1114493c4b26c77d6b5031f282bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "142f1188371be0668fef05cf3601616e05ceeead62bdf5b9e60b4b2d6914fec5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63bc46b1846986d846758a11018d4318e6eb7bacc426abf0b6651de66b1adb7d"
  end

  depends_on "go" => :build

  uses_from_macos "vim"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ggc version")
    assert_equal "main", shell_output("#{bin}/ggc config get default.branch").chomp
  end
end