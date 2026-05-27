class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://ghfast.top/https://github.com/gohugoio/hugo/archive/refs/tags/v0.162.0.tar.gz"
  sha256 "eca552a365606499e3be6c9b7d04d50560825455db5cf0cc070b5af5b8f36573"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "25fb8c74ee4f778f9545cb3b07ea950efe37344992fb762064489decbbe5a5ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d6aba48e73a0e99ae79a314f34af2405b0df8b81c5b5a59c97270a80698850d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51594b6a963c0cd4da1b98d575f67ba592a3f538c8e0459a7eacc8a808153d40"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a78cdc30976644d60b310834387a0d25e2baa8888458b0ae0e7b8bb8e5fd427"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e965f43173e024cd255f562c160d67c997d180ef52f3c4819c594cf0dc657528"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70a184cb20ef00856c710354af368837de2ab7c7f16b952c7bcc2c8a0dddd9a8"
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