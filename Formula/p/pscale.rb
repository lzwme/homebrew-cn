class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://ghfast.top/https://github.com/planetscale/cli/archive/refs/tags/v0.259.0.tar.gz"
  sha256 "522e9e832c493ddf7d43d4d18ed78581e531c4903947e499a23448ea01c88963"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e55c26c2ccd32aa8a809fba635e884de26683872892c1358bcb65c91b9f13b27"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "afa74ecc12714a2a39ea602d9dc09fd3d4a53e87440035517651b7ad40c6312e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65cc09297ec22dd8fa77bb937c0c3c90cefc5defed6d28aed6debb8012fbf517"
    sha256 cellar: :any_skip_relocation, sonoma:        "04e11c59a1f8af8d550b8a6a8b5a593ad32eb07470682c052e97f55c63d36cbd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dcfcf711622cd1510f9ffa10ffd32a774f724a9be443f4a376793c8d2c397016"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7dc72c185d0b1f26f8602965ce1cad986e3e1389341a53ecc9f149adcc846a12"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/pscale"

    generate_completions_from_executable(bin/"pscale", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pscale version")

    assert_match "Error: not authenticated yet", shell_output("#{bin}/pscale org list 2>&1", 2)
  end
end