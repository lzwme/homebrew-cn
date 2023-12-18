class Csshx < Formula
  desc "Cluster ssh tool for Terminal.app"
  homepage "https:github.combrockgrcsshx"
  url "https:storage.googleapis.comgoogle-code-archive-downloadsv2code.google.comcsshxcsshX-0.74.tgz"
  mirror "https:distfiles.macports.orgcsshXcsshX-0.74.tgz"
  sha256 "eaa9e52727c8b28dedc87398ed33ffa2340d6d0f3ea9d261749c715cb7a0e9c8"
  # same terms as Perl
  license "GPL-1.0"
  head "https:github.combrockgrcsshx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d073f3e8d11762fe8b72a3110d88a031b8f19c671f400827b68bba2adfb8b4ae"
  end

  def install
    bin.install "csshX"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}csshX --version 2>&1", 2)
  end
end