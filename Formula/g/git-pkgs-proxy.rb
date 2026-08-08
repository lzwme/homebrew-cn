class GitPkgsProxy < Formula
  desc "Lightweight caching proxy for package registries"
  homepage "https://github.com/git-pkgs/proxy"
  url "https://ghfast.top/https://github.com/git-pkgs/proxy/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "914c7b009d3a2db7fd1b50f003c24dc2c232c8ad7456a17901a09fb78d64f24d"
  license "GPL-3.0-or-later"
  head "https://github.com/git-pkgs/proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ca71d5eeb5e019540a22da820181899522e37f30a10ccfc1fd2ee1b47882ca6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29e9879627ba81ea5e145b849f791b1546ead26b2a13b394ac3b2f1f28171b00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77e04cf8cff48ffbf616a648e93e7ef4274c98d891a82c10feaab789e5afeca2"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5ff70c21b77917011e80a379fd9de39d05b625fb3f5382f47e68b862c77645d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "878377a7a121970036d17dcac698e86d335a71f697a9fa14b4dbe1246286925c"
    sha256 cellar: :any,                 x86_64_linux:  "6f6c8ecabe6b6dbe05763a30961c7edc8e80a28193faa9d8537f04813c2ee563"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X main.Version=#{version}
      -X main.Commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"proxy"), "./cmd/proxy"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/proxy -version")

    output = shell_output("#{bin}/proxy stats 2>&1", 1)
    assert_match "database not found: ./cache/proxy.db", output
  end
end