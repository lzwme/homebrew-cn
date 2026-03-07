class Stencil < Formula
  desc "Modern living-template engine for evolving repositories"
  homepage "https://stencil.rgst.io"
  url "https://ghfast.top/https://github.com/rgst-io/stencil/archive/refs/tags/v2.14.1.tar.gz"
  sha256 "ff88b28d051228d6461fb0875284e1658fda5659c0a6fce2dae8f9825a1b8d91"
  license "Apache-2.0"
  head "https://github.com/rgst-io/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e84ac966c07a96eeb34c99c87c2cc3cc8968427cbde83060f9f16cb6463adf27"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55f34c8c8c4added4ac3a4ed4fb37c48ae87176f37819954dd64536495b0c6f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1e8d4ce0d3118faea1b4a850622578e700f9929a3cae46ac247b7a5ee019ec6"
    sha256 cellar: :any_skip_relocation, sonoma:        "98f2a0365a4b01da1d9c5a1778b8a1f926da472bd52a1c9ec68d938223652424"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "650b5f1747dc935f159a5f120779ac642392303bba9f6debdcf99f473c4a1150"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "689e15f2687eb3d9e6c3c0830644749ce1cf413094a69f1c4f8b47ab3bb95cea"
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