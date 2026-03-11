class Stencil < Formula
  desc "Modern living-template engine for evolving repositories"
  homepage "https://stencil.rgst.io"
  url "https://ghfast.top/https://github.com/rgst-io/stencil/archive/refs/tags/v2.14.2.tar.gz"
  sha256 "0f514477eedf86abdbd2486b33a8067de3fcfd4d893f43a1e0d8c354f806ea62"
  license "Apache-2.0"
  head "https://github.com/rgst-io/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0432b9c6873260fc3ba341bf580594542f6a39743965a95ed6afcdd0782f1595"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0af6eb400bb154e7f432041e2badd94b7cae9ba3691779308094b39cfd29f35a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c1b42e686fadfbd8d5e5c098d121d1a5168a5120ce7e75676a16ef22bb76702"
    sha256 cellar: :any_skip_relocation, sonoma:        "c094d74570664548f89609fb20b1559769c4d30925ae936b9b34e3544e1466df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80f4dcbc8a8e0168eb28d4a7a3407b86125d019a0089a4b8b1da9c8d9b0ba5e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b93484be5d8ea59988e28d1268b8c573453efcdde369743ab8940b8ea002c0b"
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