class Ggc < Formula
  desc "Modern Git CLI"
  homepage "https://github.com/bmf-san/ggc"
  url "https://ghfast.top/https://github.com/bmf-san/ggc/archive/refs/tags/v5.0.2.tar.gz"
  sha256 "b2eb14ed42e47269c1081ac12d5da46d8c4868851a1e82a7b77929ef5df367ce"
  license "MIT"
  head "https://github.com/bmf-san/ggc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a07e8aae1a12b7c2a2cde233fd2225bcf6b3c6b0c77a8eed4be9fae6b5adf722"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a07e8aae1a12b7c2a2cde233fd2225bcf6b3c6b0c77a8eed4be9fae6b5adf722"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a07e8aae1a12b7c2a2cde233fd2225bcf6b3c6b0c77a8eed4be9fae6b5adf722"
    sha256 cellar: :any_skip_relocation, sonoma:        "0963c2c8e31f6a71c98adf86a6694b5101e0c081bcfc84ed1d5d25aa998fb8ff"
    sha256 cellar: :any_skip_relocation, ventura:       "0963c2c8e31f6a71c98adf86a6694b5101e0c081bcfc84ed1d5d25aa998fb8ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d9aa6ec76eac49e7ee3d0270f07e95fba40ed612cdfd8d5b4d1678d23de2c46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81761616da2f7112771a2a76571d1584101085ca80c86d4b486ffb9889479211"
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