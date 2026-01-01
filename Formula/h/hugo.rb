class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://ghfast.top/https://github.com/gohugoio/hugo/archive/refs/tags/v0.154.0.tar.gz"
  sha256 "47bf1f2b084316cdcc84820e682ee8ffb78f3df99d599e6a9efa0488e721e15f"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "445e8e622e97c3a6f26bb080242943f8396bba9e9204613d76014555ef3d4e0f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "188c75ed6b1a3c2e63016dc5aef3605aed58cf16e71d5c67b45de3267f26fb9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2aed4e51a298c8f9fcbe1e588ac5f1ead66de805da1a94b1176db386ec0254f"
    sha256 cellar: :any_skip_relocation, sonoma:        "bbd0d935d6934e70bb594f1912864a6e51b3eadb540dfbd959f55150a5d61060"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da93af501605a1ad7fa1b2957fdaa109b7d5282a9245fff468dbe39d818badcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31d5edda4ca35f82552bb8f37f64c4dcf23a19db797956a301e03f3d296734e3"
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