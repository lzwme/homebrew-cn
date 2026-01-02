class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://ghfast.top/https://github.com/gohugoio/hugo/archive/refs/tags/v0.154.1.tar.gz"
  sha256 "8fe334f2827cb4c89d72d9de8bb813289285d796d79fdfda927901732cbdf4ce"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2dffd289f8790b2928338b9389eb82b4cdf78aef3ee2ccb6c96d5becc35d6b79"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e353af7195ace0210f3d4bfef299c3b58434459a82cda2b47c61af3fd9884e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2fdb450767cc605f798564b7e119fcb5fd1340928a1e8396424b20d06e790e79"
    sha256 cellar: :any_skip_relocation, sonoma:        "61c9614765936a18881a61c6f17f87e23e135a4a78785e6e9820e43ca91ab97c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96216a76645051aed07dd56a5546cabc8192e700a4a2caafa2a9715710c1c11e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91655efa355707c7f6f93a7cd111f1f4ba95fed08664a08d4e835aeeab60190a"
  end

  depends_on "go" => :build

  def install
    # Needs CGO (which is disabled by default on Linux Arm)
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X github.com/gohugoio/hugo/common/hugo.commitHash=#{tap.user}
      -X github.com/gohugoio/hugo/common/hugo.buildDate=#{time.iso8601}
      -X github.com/gohugoio/hugo/common/hugo.vendorInfo=#{tap.user}
    ]
    tags = %w[extended withdeploy]
    system "go", "build", *std_go_args(ldflags:, tags:)

    generate_completions_from_executable(bin/"hugo", shell_parameter_format: :cobra)
    system bin/"hugo", "gen", "man", "--dir", man1
  end

  test do
    site = testpath/"hops-yeast-malt-water"
    system bin/"hugo", "new", "site", site
    assert_path_exists site/"hugo.toml"

    assert_match version.to_s, shell_output("#{bin}/hugo version")
  end
end