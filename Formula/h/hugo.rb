class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://ghfast.top/https://github.com/gohugoio/hugo/archive/refs/tags/v0.163.0.tar.gz"
  sha256 "8470166ee4f228a88bc7cb527dfb33b6107d10ab8af5f8725a2c7ef158401451"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bfd56871ad790f4a514f6c780980f9805d83455b344f6f5c1433e421fd502c5f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b60e090cbb2a9e1fbad5f19fcc6798294edd30bfb824e5952471c50dea5eb8ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "042c32e04cb40772fe99f59be9da06e4c521993c4430b83519b46a967f0abbee"
    sha256 cellar: :any_skip_relocation, sonoma:        "9594f1b0b2d3305df9345d7e6ed3ea2d6ab33b39489d94c26f62164a6c8b4ad1"
    sha256 cellar: :any,                 arm64_linux:   "59b7acafe95a770f367eb879d2a0985c49dcfe880c536aade52b5ddaa7e7cd5d"
    sha256 cellar: :any,                 x86_64_linux:  "aa908c083e425c9231e12505bc42c0acb1f21afc5687f161e760707f77079bb3"
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