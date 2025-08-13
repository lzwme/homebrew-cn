class Px < Formula
  include Language::Python::Virtualenv

  desc "Ps and top for human beings (px / ptop)"
  homepage "https://github.com/walles/px"
  url "https://github.com/walles/px.git",
      tag:      "3.6.13",
      revision: "e6bd4779970fc448cabb5b714cb737005d6c4318"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d4a1e994cc03c26be44d6683939626e92a593894e9993dc4309662d47a65283"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d4a1e994cc03c26be44d6683939626e92a593894e9993dc4309662d47a65283"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9d4a1e994cc03c26be44d6683939626e92a593894e9993dc4309662d47a65283"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c8843cd23beef1c971c277f0fbc1a6dc1174455e3986121c52c64403b369c03"
    sha256 cellar: :any_skip_relocation, ventura:       "6c8843cd23beef1c971c277f0fbc1a6dc1174455e3986121c52c64403b369c03"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d4a1e994cc03c26be44d6683939626e92a593894e9993dc4309662d47a65283"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d4a1e994cc03c26be44d6683939626e92a593894e9993dc4309662d47a65283"
  end

  depends_on "python@3.13"

  uses_from_macos "lsof"

  conflicts_with "fpc", because: "both install `ptop` binaries"
  conflicts_with "pixie", because: "both install `px` binaries"

  def install
    virtualenv_install_with_resources

    man1.install Dir["doc/*.1"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/px --version")

    split_first_line = pipe_output("#{bin}/px --no-pager").lines.first.split
    assert_equal %w[PID COMMAND USERNAME CPU CPUTIME RAM COMMANDLINE], split_first_line
  end
end