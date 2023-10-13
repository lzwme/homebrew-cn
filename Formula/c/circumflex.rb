class Circumflex < Formula
  desc "Hacker News in your terminal"
  homepage "https://github.com/bensadeh/circumflex"
  url "https://ghproxy.com/https://github.com/bensadeh/circumflex/archive/refs/tags/3.4.tar.gz"
  sha256 "911deed5eabf9ac1a218decec86357894a8a77deb0f33735f5faad8138ba4ff5"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "671eb0f32aea8923e55b3f8d910f614dcecc0e89c7f0a220dcc6837485ba16b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a773f40874f88b907e23bbfe372beefdf5e127461e7f61e4dee3802460cd7c37"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07af3e61ff32b873de8c2861ee38de9deace3d5a5f849b57fd6804a5260103f5"
    sha256 cellar: :any_skip_relocation, sonoma:         "d24db7a043efe062338a32ae56c0947a9f0286d508c91a9be7d7aacdcd36c5bf"
    sha256 cellar: :any_skip_relocation, ventura:        "2b93078164ecfd9eeb4a50f8b439241a763aab6b67a00eb676d7d6db7eb31d98"
    sha256 cellar: :any_skip_relocation, monterey:       "8a9af69756bc6623341a66d98c3a571ed556a716e141413acc84c0ce21b9aff1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c6ab73bcb9db986943c946bcbbf32c0f7fd2f048854c857a307fa7e31073f8d"
  end

  depends_on "go" => :build
  depends_on "less"

  def install
    system "go", "build", *std_go_args(output: bin/"clx", ldflags: "-s -w")
    man1.install "share/man/clx.1"
  end

  test do
    assert_match "List of visited IDs cleared", shell_output("#{bin}/clx clear 2>&1")
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    assert_match "Y Combinator", shell_output("#{bin}/clx article 1")
  end
end