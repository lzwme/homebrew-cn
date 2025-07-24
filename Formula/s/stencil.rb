class Stencil < Formula
  desc "Modern living-template engine for evolving repositories"
  homepage "https://stencil.rgst.io"
  url "https://ghfast.top/https://github.com/rgst-io/stencil/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "059b4cf713c59ca8cec2eae108da13fbfb4a3182d8b82b5eba8ce653a086ad9e"
  license "Apache-2.0"
  head "https://github.com/rgst-io/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b7d93670592db203e1643afc0e75c441556b5b9e5f2b634d3e13bb7a40bbdc8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bbedfe044913b3d563a31cf93d0e25f9df6f9eebfe9cff6742ca8ddf561a465d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2c218178897852b332965831e5a996af94a1361e7dca8ba0784b227b6c1c98c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "62cde3e82be038fc2d6c371b40dfd85982b5825c00fdcc60338fc27007a13feb"
    sha256 cellar: :any_skip_relocation, ventura:       "f7467d60a62345e66e73c7856082cc2a9307983d74b79e2ffee17950918c98c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "521704b9e101b13dad7793f13cfd70da6f834a0d3e29f05b7374fcfef7de51a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8824e5b388506c44501bec2abbff59b66c7bdd1c16d4831931fc2948f731fe4"
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