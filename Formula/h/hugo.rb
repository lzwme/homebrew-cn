class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://ghfast.top/https://github.com/gohugoio/hugo/archive/refs/tags/v0.153.1.tar.gz"
  sha256 "a956b9e457dde7132ee0fce16466477b41627236856c31b7e9e610492385e772"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b9d3a7b962e905e7111e92fff5dc6717be13a1c4ac335fe2588e6f83c493a58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3e04c9e50cdf61548f8147b505fe98dcd3cb2af595459cedc303c74518c8809"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac9b7d1414eefa85fdab215756cd07fb73e5d9436ff8fceb793a0efdeba43041"
    sha256 cellar: :any_skip_relocation, sonoma:        "471eec640cd02afa4a60692c29de60a68e6c42f47ae79c50778227604b65ac60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa631ab60657d75d26edc436536acb599e860c08a6fbcdad16522b1613635aa4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31826c9e88735c0ecffc611f5c6effa265f084ccb27c2c16f7b59d0fc7365a54"
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

    generate_completions_from_executable(bin/"hugo", "completion")
    system bin/"hugo", "gen", "man", "--dir", man1
  end

  test do
    site = testpath/"hops-yeast-malt-water"
    system bin/"hugo", "new", "site", site
    assert_path_exists site/"hugo.toml"

    assert_match version.to_s, shell_output("#{bin}/hugo version")
  end
end