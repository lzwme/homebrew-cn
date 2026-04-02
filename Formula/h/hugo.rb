class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://ghfast.top/https://github.com/gohugoio/hugo/archive/refs/tags/v0.159.2.tar.gz"
  sha256 "eafd94cae9559f6dfd160cf6294ad67240517a82f2bed45f0ec13a3f1bf40532"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "714ca3887df7d237e6aeb3a978fdd3c443a3e234a8b7c966ad2785faf14f263f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e765ae092490e8edc0b3066904645f667924ce43f131cd1f717b26847f3dd61e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef8ca0d3d046c2fac0679da20deaa43b83888070f9dfb1f0861471d9041d3bf1"
    sha256 cellar: :any_skip_relocation, sonoma:        "615c38414c70aa144904a7e74c05a8e024f3bdee3da16b07c62f7a0bdee6e22e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b140e3ce1678b92a2eb488939d8cedf6e3fb3ab4662de104a9e5e7207f53a90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f624095cf807cf265305228430e842d8460dda95c896c85cfdd0461af7aef83"
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