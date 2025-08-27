class Stencil < Formula
  desc "Modern living-template engine for evolving repositories"
  homepage "https://stencil.rgst.io"
  url "https://ghfast.top/https://github.com/rgst-io/stencil/archive/refs/tags/v2.9.0.tar.gz"
  sha256 "1b8a18d25fa5207d5a5f6f83d3e284cdfca44f436a808994dc220f967b24da30"
  license "Apache-2.0"
  head "https://github.com/rgst-io/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da828dd847c19d5cd181477907ad9df2a749611d584de2d2836506a780bedeba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74925fb4cee9b277de2b45b04ddec9bbcd3e8c481a02c70208bdbc4fbfa52117"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0447a2104277b4b3e31ac6aa209bb84ddfa23ef21563864029935dd85487e671"
    sha256 cellar: :any_skip_relocation, sonoma:        "d87f5e1a62a50153e8699d9928e3335b69c2bce52fca4723d711c4033adcd5f2"
    sha256 cellar: :any_skip_relocation, ventura:       "50061b9698b470390476b9b10754ee0ba251ebfbd587e38aab0145a92417be80"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5999966c0cda4629610db032a577fed935d34fb0960aa5389954c8445abccd73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07686ed567c226a5a704447ff51a39d2899b0f9f904ad03777273c8b518f523a"
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