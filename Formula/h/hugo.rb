class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://ghfast.top/https://github.com/gohugoio/hugo/archive/refs/tags/v0.153.4.tar.gz"
  sha256 "bded91b25ad0a64731f3fc076340621b3c514c54adc6f7b6e7dbae58d4bee1c0"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "32d12ecf79611af7e0830079e0a4166e10209286fd94c9c74a04c01653aed666"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77ea45c057806244e9494f69fc4f4479f37c182d60898fed05085c39973b0d08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5efa59bbce116c15d97e27ac563aa1f5169834a12a437b4ecf411c1b7d67a017"
    sha256 cellar: :any_skip_relocation, sonoma:        "be760586c223cef1a785141936254a2889677d389fd32392a45ea6c3b50002f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb643e72e22d3ff72b7019528f70b520f41a9a6083bb1ea458edb5ad784952fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c41cfb339332aa0421d571e99521a5bddbc780308f3410d957af93320d800e9a"
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