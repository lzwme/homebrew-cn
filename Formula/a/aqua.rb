class Aqua < Formula
  desc "Declarative CLI Version manager"
  homepage "https://aquaproj.github.io/"
  url "https://ghfast.top/https://github.com/aquaproj/aqua/archive/refs/tags/v2.56.4.tar.gz"
  sha256 "3cfca5822a7bf1bf06069f863df8d19cc52c362aabd05f6cc971210eb7a53b88"
  license "MIT"
  head "https://github.com/aquaproj/aqua.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da040c963fae88ddc9040aad08d6b603cf9799f4b4854940ded55ef4f65d71bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da040c963fae88ddc9040aad08d6b603cf9799f4b4854940ded55ef4f65d71bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da040c963fae88ddc9040aad08d6b603cf9799f4b4854940ded55ef4f65d71bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "43bda7f298895152a2f14de03023e7859b1aacc6e65ed92ca188088d27deaf3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a13e0e7e8c5b4aafc8e6950a540fde4ecc6fd9b09ad6219ffe8ecf22006f98ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c98addca7e35edee5f42ed9450785d1cce7b999fec9a645fc99bb10837c52763"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/aqua"

    generate_completions_from_executable(bin/"aqua", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aqua --version")

    system bin/"aqua", "init"
    assert_match "depName=aquaproj/aqua-registry", (testpath/"aqua.yaml").read
  end
end