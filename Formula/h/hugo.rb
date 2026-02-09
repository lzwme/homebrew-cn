class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://ghfast.top/https://github.com/gohugoio/hugo/archive/refs/tags/v0.155.3.tar.gz"
  sha256 "2e37575fd0627f6f4696027cd90c99d48376b403f71d58945987ad967890b283"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "76e4b4843db27c73d79be0b71151d2186f7d2e70fd2d0f15f8b6f85b3f46ad38"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53723b288e4599f88923716aef3e4a1de4ea9ce6f0fc7cad2fcae85e81e6366f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "436d59821813aa892230adda929cf21806df02786f1aad367c2155be0a53c522"
    sha256 cellar: :any_skip_relocation, sonoma:        "89dfa76ff5298bcc6538d8cc4a7c65101d7a20ad6bec1808c49eb1342a814625"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e66830eb78607e05250d286f12bdbb6e65f2582ff689dc2580c2c3d8a280b838"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdee802b3a3d16de0567932db75b527784befe9c2910a2ddd14c1dd5d392806b"
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