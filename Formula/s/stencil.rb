class Stencil < Formula
  desc "Modern living-template engine for evolving repositories"
  homepage "https://stencil.rgst.io"
  url "https://ghfast.top/https://github.com/rgst-io/stencil/archive/refs/tags/v2.16.0.tar.gz"
  sha256 "f8748e97b05c21b48fc4335e99d5418703e0a8eb8a8e7e4dd9e57f5c7fef5df2"
  license "Apache-2.0"
  head "https://github.com/rgst-io/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "834e8f3aa6c4d9c2cb1960453e24d2ef3419a631ea8c55af3c1484b894ed3689"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0466c1767bb8a421385b69d16ef264c0125bb98d63df6e3e8856a18f9d90cc24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89805914b37c684ebb579f994521bd5691f6ad4942f63321888b088a2e7256e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "7269e0b72ab733bba96e4db3a18823f618e57c8533522e07de807d758dc915af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a48bfd1d05a06c8cbbdfb4bf7a50af98aa1e35ef92dcda345ceb670f97a06dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "daae205138baae22b61fd350da8cffdac088c403a9ca1eb26122c6faf4fa114e"
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