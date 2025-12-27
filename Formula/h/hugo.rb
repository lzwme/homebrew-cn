class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://ghfast.top/https://github.com/gohugoio/hugo/archive/refs/tags/v0.153.3.tar.gz"
  sha256 "ff3368b6b8a84b6695ce22d77049e1608ed59b7c1522f573b3f6fe4ad03b7915"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bfb7f1554be28e88f8f4905f87411462e3c7e8497de4297a8cc6c3d5f8581fae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5943b5e32611d4f432c7d55f5bf338ade928cdd4f25803a6dbd9c62b94e8dddb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02209bdd56349a03959baf05ea4b84d9dad3ab85b9c91f9cda93857f2eda7b16"
    sha256 cellar: :any_skip_relocation, sonoma:        "177c5d95bac0d00661e9710a5b7ccbc8dc9e0bd22ca1bd617d90be6aa3a25977"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6463218556333e37fa4baaa90145e9a4db77b469bdd2b52f74f41c34b69a2158"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5240c54c439354cba3cc99149ca69b6d0434c2c5b49ec2c1923e8abcac86d4f5"
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