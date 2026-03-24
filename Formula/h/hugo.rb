class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://ghfast.top/https://github.com/gohugoio/hugo/archive/refs/tags/v0.159.0.tar.gz"
  sha256 "a4e70460f4e9721606862e0e4e5d8036726974ed958bcb5efc6db95f7cd8fa7c"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d7ad3ea21a2f2c6f4a649943ef8a64c85b1c2d17ae9d2c3278e9087a3732fe4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fead94e9384ee90783c9c331a8e58b746086399dad287e3dfdc0da35817e1add"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b83d079a15908f729fe13031bb596664b69d11bbf920ddbb72ab676e36b2cf2"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca914e4292ae993027f56e8109b26e1c713101a081dffe907dd3581e0f61ca76"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8dd248ec5fade4ef79ef9e0229bac461ea6c9ff785900b9f4333c990bd819ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "868d77501c2cd8842c44ada2236a39fd42fb104c761fa2be3017c7ea59529cef"
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