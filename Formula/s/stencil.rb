class Stencil < Formula
  desc "Modern living-template engine for evolving repositories"
  homepage "https://stencil.rgst.io"
  url "https://ghfast.top/https://github.com/rgst-io/stencil/archive/refs/tags/v2.11.1.tar.gz"
  sha256 "5b2b18c60f7eeeb49fba72e7bf76a1f29a48b87b7161eb427d1d5e95dbe9acf6"
  license "Apache-2.0"
  head "https://github.com/rgst-io/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1abf85e5b650b1d33ddcc31bb5a5f6692da82a7302c242ae764cbfba1818ec1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7dda68832a7dce20732886196fd8b1e37cda5ab9956b240474409b3ece5de17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7478beed2a6d6ec4e9099b923cf5d8792541e401ad3978bb7962e2d2db8b4182"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2698535c3edfba585c98ad76bf317c271702cf95904ff3fd04137298ebbefeb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c608057e4f3eaa6e2a661a4d58dd78b638e591d390728be24f8c753c063dd81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fecdd3b138edd46cd808acd074c21828341c376989143b6c8905ff44925b5d98"
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