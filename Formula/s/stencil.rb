class Stencil < Formula
  desc "Modern living-template engine for evolving repositories"
  homepage "https://stencil.rgst.io"
  url "https://ghfast.top/https://github.com/rgst-io/stencil/archive/refs/tags/v2.14.0.tar.gz"
  sha256 "cb21ba5c4e12e88acf89e7ca84c069515e577e99c6cc4c764e7a81bef4c7d91c"
  license "Apache-2.0"
  head "https://github.com/rgst-io/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5455ec5bde90ac19001de847c15dcf3fbba7f4f5aecc92ec22fccd8abe3a89a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fdf5a43d31df64461077793298faa57bb282a36531bc336e3edff2b2e049aadf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0802471e382db316f3d6ef15e2145743efd10eb84839c7036d0dc387e85948f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "e865214a05a1a99353f12f04a98ef7c3b3558c24c10f1e80d275297dfdd0d051"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55032d422a3f3a8afb79c13b730e4bbcf32482a6ceca340265023c88947d3738"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d4d80183c2e875dae39788c73c1bba27a0bb1e2a91754aa0678eb7bdf7700b5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X go.rgst.io/stencil/v2/internal/version.version=#{version}
      -X go.rgst.io/stencil/v2/internal/version.builtBy=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/stencil"
  end

  test do
    (testpath/"service.yaml").write "name: test"
    system bin/"stencil"
    assert_path_exists testpath/"stencil.lock"
  end
end