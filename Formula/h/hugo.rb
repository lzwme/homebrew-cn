class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://ghfast.top/https://github.com/gohugoio/hugo/archive/refs/tags/v0.154.4.tar.gz"
  sha256 "2cca8539316312cc532bd8a548b3ddf25cf818ad3b07586e7883bf8dad04d824"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81f5e97f8bab00025846a7b356f9e23c151336107ee7d81ab019b862b73bfd96"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b9f7ee2acf3c7f5ef901cd57e89fa590e60680afe41854cf22a1643cf5f6e79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9c061e2ca6b2ce11ea7b089c762d15264b334f5ac7bd84ddb6aef816623ce92"
    sha256 cellar: :any_skip_relocation, sonoma:        "8019dde98fabb60794c6dc4cb9e11e444e764d5ca58622a6e69b3761a1c7e916"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae85bc7ff28043ba72f2409ec85b1f9d86a2d082b44c519d55838cbce251baec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ff191648b0f3724b3a0f8295901cd89ecd87e6cec52ea020dc1b387a86d930a"
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