class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://ghfast.top/https://github.com/gohugoio/hugo/archive/refs/tags/v0.155.1.tar.gz"
  sha256 "50c007fc904561a58cb4f7575361a04a31d18219d04a57dd58cddd4b252eec8f"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f24baacdaf426cbe9f7706c4e556a47a95885340eb4e3d8d77c6aa59fbd75506"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f7b0b62921c6486a2bee4140f0057f06b7e8439a5a24943b3efb901a3f3993c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec64058a7314aa9374b75ff22fd64bbcc2bea7bc965d52d5d11b20bc57116489"
    sha256 cellar: :any_skip_relocation, sonoma:        "370b67d138fc83d0f23ef0a7368956a529cf6b79997d4236574f82f65e7e7151"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6e9a292286337126efc5da6a95e4f08bdcb1811d608019bca69f42c707165b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "508a0e223d39d14c84c4e83637be84490f430c7f7a4566f6b97dad8b53843473"
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