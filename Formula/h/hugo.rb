class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://ghfast.top/https://github.com/gohugoio/hugo/archive/refs/tags/v0.153.5.tar.gz"
  sha256 "23f116288670939e5920bc60eab094b86aefc2013125eb73eadd1ed8e759daa5"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa00162d40c4e37dfbe4f3391acfc6956113ca2a2b0a09e2b396485dffb4908b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cca65a0e67c1bab5d1723bd90adcb7a3c1e9abdea512c0d7d07ed81f0f16ef67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a1f26225198c2d4f136787de78f4c51c947f00c2d66506d9c3582e355c6ca3c"
    sha256 cellar: :any_skip_relocation, sonoma:        "6df776c62ecce2deab66d406fcf5c6c3e025a15aa03225e3d51d185cde76dd32"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "393c86ae1c1be48ac2dc60a656bd73a10d2b054253a1754aee965ef489a78643"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1be6da66fe4fb74b8913f964b9c48d8d536913181b1f16ae0f42febfff8daf29"
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