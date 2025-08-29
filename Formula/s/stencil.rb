class Stencil < Formula
  desc "Modern living-template engine for evolving repositories"
  homepage "https://stencil.rgst.io"
  url "https://ghfast.top/https://github.com/rgst-io/stencil/archive/refs/tags/v2.9.1.tar.gz"
  sha256 "78dc152d0af69e3a204f7499a9686bd2b4a3bceac22b411f86dc693d987ca3cd"
  license "Apache-2.0"
  head "https://github.com/rgst-io/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c265e3732910d83b18f5694db6c46290b8d40527093948e91ec8cd565c57db5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2051f4b0ca2988be4567a7ac554097b8020d88710588659ed9969804feea735"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "63c227b1b7cdc2df41c9762f600248f54e15e3b44dae0e57192cf2aceabef3c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1d602ac770a62d737f8b2289901c3ee0ca23e84f65f9a76fb120441fc85a761"
    sha256 cellar: :any_skip_relocation, ventura:       "7b29b112d97af17da7d7a6c5db0dca578e13cf32fca9025193387eab9e652e6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50db47cbfd68f3f3cac942c2c498e30ef4b1d4503670975d824dbbf232d7493c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2852da5c9b05074211888f0e34079d30dc9ed22742abe4e1933b63337d61d202"
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