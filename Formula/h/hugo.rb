class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://ghfast.top/https://github.com/gohugoio/hugo/archive/refs/tags/v0.154.2.tar.gz"
  sha256 "7eb7461a1871bdefb8151db2c180b088c828a6b96dd3ff6cfaecd858a69c690f"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc79acc73aea3ba6805f612ae39d78c968fa2ff13a794f245f17830890929ac2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1684096e65dcd61270fc08596b548970d752dde6849d6f9aa71f6b1b0e153e8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df892ac1efddb7c24f2b34099cf7f642a9614979cec7162c3bdc4fcab866f899"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b8cc029c876bc056a33fca7da2ff91a155b27f2cbc191430909b2a41c450826"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8abc9873f4e022d037e8827fdb168fd49468ca9d5a0d621e688bcb78b464f4d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d8eb0d86760abd23e2d2e24bd124bd0a781d3eeaf47105bc549ac6dae17f329"
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