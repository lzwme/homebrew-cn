class Gastown < Formula
  desc "Multi-agent workspace manager"
  homepage "https://github.com/steveyegge/gastown"
  url "https://ghfast.top/https://github.com/steveyegge/gastown/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "1fc02fef9b46544af153402162201dcf89c0de12f09968741748355ee04752ed"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "385180674678331c0f8e97199f9cabb444c67b4132439aba72dcc312e541ce33"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "385180674678331c0f8e97199f9cabb444c67b4132439aba72dcc312e541ce33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "385180674678331c0f8e97199f9cabb444c67b4132439aba72dcc312e541ce33"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3e1f12290bad73da024a967b25da59bd31e0634f976d67759ec2cdd08e9e9fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca79144c99d60de9e763a4287421a9cc1167f534d630211def5ffe5dcd1636d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0281ac653cc07a6e0ba5cf1ba18491ebfdd222e2b1577e03793fcf308e400246"
  end

  depends_on "go" => :build
  depends_on "beads"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gt"
    bin.install_symlink "gastown" => "gt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gt version")

    system bin/"gt", "install"
    assert_path_exists testpath/"mayor"
  end
end