class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://ghfast.top/https://github.com/gohugoio/hugo/archive/refs/tags/v0.148.0.tar.gz"
  sha256 "cd4920d37b00630229dda11d789a68860eebfa6cd9f9ea8a637bec43c6516f0b"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fda522e4f4bb5bac039124061e231dee8dcd426a107cd68362ca320b42d91621"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34fa584f63c0aafbf8a9de3ffc4faa63b4d763b826b4c21c9a83b3b8f530d833"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a1da4d8fd10ee38061face8faeba24c320a6eadb09b496df704b7a1594f13963"
    sha256 cellar: :any_skip_relocation, sonoma:        "63e1df077d156fea529bf9642a2662e2383b76c9ad56f5a895d04a1cc710dd42"
    sha256 cellar: :any_skip_relocation, ventura:       "97355e0c2f9194306eeb4797f194e101b4f0b1dad0a381dd51e8804b79601b5e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4a3cf9a0f0fcf2ed84bc4ab12950c83fadadea513ce3fc53b2ef20be508fc3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1bbda7b12107499c1b9ff804ab995a1bbd8f5e6cb03f841b6f2ab279cee03138"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/gohugoio/hugo/common/hugo.commitHash=#{tap.user}
      -X github.com/gohugoio/hugo/common/hugo.buildDate=#{time.iso8601}
      -X github.com/gohugoio/hugo/common/hugo.vendorInfo=brew
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

    assert_match version.to_s, shell_output(bin/"hugo version")
  end
end