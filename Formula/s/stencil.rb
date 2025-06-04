class Stencil < Formula
  desc "Modern living-template engine for evolving repositories"
  homepage "https:stencil.rgst.io"
  url "https:github.comrgst-iostencilarchiverefstagsv2.5.1.tar.gz"
  sha256 "36ec742a7a7c98c2db102aa7b15c5ac681277c7464c2963e9a8f5605da521c46"
  license "Apache-2.0"
  head "https:github.comrgst-iostencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6bcbaaa6ebda6e158c47936eb984ff45c224d718361cefe58239bc61d5c0bde"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d208cfc10eb3a5ce140116312841731067fe817a52e25bcb76e214ab34da38d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "97ce230be1fc83263a3291ff2b1b4aecfdd783eb32012750504cdad7e6721b7b"
    sha256 cellar: :any_skip_relocation, sonoma:        "13b22ae590c1e03cb32a248f127aaa85ed31221f3494d55348f50ce0123f642b"
    sha256 cellar: :any_skip_relocation, ventura:       "544801d751b70cd1366e04e6f4dfad6ecc70a4d67a61b8cc9fbf20826e0a86d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c04dbfd3e1ea6083fcf68c814aa265112d5cf6e6c6ea154abfd3c2a51d5e916"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78996907ab18277e5a0481d14291a50bf02ca0eb8a9117c636e53733b1d43629"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X go.rgst.iostencilv2internalversion.version=#{version}
      -X go.rgst.iostencilv2internalversion.builtBy=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:), ".cmdstencil"
  end

  test do
    (testpath"service.yaml").write "name: test"
    system bin"stencil"
    assert_path_exists testpath"stencil.lock"
  end
end