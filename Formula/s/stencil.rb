class Stencil < Formula
  desc "Modern living-template engine for evolving repositories"
  homepage "https:stencil.rgst.io"
  url "https:github.comrgst-iostencilarchiverefstagsv2.3.0.tar.gz"
  sha256 "7e0b283b6d6c97d9b7d5b9418a9217016494f9fee9460b3953a805fcc9548296"
  license "Apache-2.0"
  head "https:github.comrgst-iostencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f3f27befeb4ebb961c9f973d4320be34d486a8d5bbc2a2bcad055e817c1cac4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1c3b03ad4de9bff542c80895941a3f502c83e0c9462e98b623c0247c2e4f379"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a3182ec4f2c077df6373d4e62e5776d18ab0fed14922b612411f7136913c386e"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ddf7b12ea85a2b86cd4ebea5e96e86d5a99f0b08d62dc96e371f5628fbd7440"
    sha256 cellar: :any_skip_relocation, ventura:       "d27e788fe20be3be61f335936c758c141d0d2d1b619ea80f82c85a186f5d5dce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29e49f89b72c8003f00040c977ad3dc0ff868720bb61e22d153cddabfe610706"
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