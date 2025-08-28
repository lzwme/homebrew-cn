class Px < Formula
  include Language::Python::Virtualenv

  desc "Ps and top for human beings (px / ptop)"
  homepage "https://github.com/walles/px"
  url "https://files.pythonhosted.org/packages/6c/84/0d8c82c54f5014340df9e44d89e0c09a9261a61bfce656f0a7f09eb3c275/pxpx-3.7.0.tar.gz"
  sha256 "18961d377c41f65fa944b5c08db6f60a5919c15dbcd83df9f8e95ff594241cb0"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dbc12da3ec4c8724b3126a1d814f35b3278888e3d93e423f82fca6f1e15d635f"
  end

  depends_on "python@3.13"

  uses_from_macos "lsof"

  conflicts_with "fpc", because: "both install `ptop` binaries"
  conflicts_with "pixie", because: "both install `px` binaries"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/px --version")

    split_first_line = pipe_output("#{bin}/px --no-pager").lines.first.split
    assert_equal %w[PID COMMAND USERNAME CPU CPUTIME RAM COMMANDLINE], split_first_line
  end
end