class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://ghfast.top/https://github.com/gohugoio/hugo/archive/refs/tags/v0.153.0.tar.gz"
  sha256 "bcfadf6e43067887d0ea0df1caea1e6d1feecd769794c341d89a3661ba680482"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da06d020258087a230d23658bc2b15f5c8e3616f24ef0a3d34f37684f6c1adbc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f33bb74edc53c16d9e5705dfd71d233c8f0c047b4985ec7dde51d2377b0743a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "151fa2ac644109200d65d7d9d60deec9a930d36e7f201ddfa895452285076b05"
    sha256 cellar: :any_skip_relocation, sonoma:        "70e5c641bcf80a2b6bb494f8deddedb276c0fd0446a5d043537e23665fc5caf5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8cf95a0540e197db54d3d9433c5c764a8efd826b9d13978d4aa0b3a9ca6cda0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82e784f368ff48459c8617bf14ff305ed038c132f62dde6d425301b5a751efbf"
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