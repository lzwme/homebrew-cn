class Has < Formula
  desc "Checks presence of various command-line tools and their versions on the path"
  homepage "https://github.com/kdabir/has"
  url "https://ghfast.top/https://github.com/kdabir/has/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "9693e50673fffcfdfe0eea2b9c3c4455c5c46c4eee390bd3cffb3e51bbfc291b"
  license "MIT"
  head "https://github.com/kdabir/has.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "601865ae2b656ff5e957d4c7e01e67ce9cbeea244bed03e95d73fc26b2a50f6e"
  end

  # Fix long option parsing issue, upstream pr ref, https://github.com/kdabir/has/pull/88
  patch do
    url "https://github.com/kdabir/has/commit/32418e7c59c6c1801f3828bca1b2feed0894434f.patch?full_index=1"
    sha256 "2f0c0fcc53365d92f2008d29d69f7477c2083ecf123db6fc9f2e154521c6ae86"
  end

  def install
    bin.install "has"
  end

  test do
    assert_match "git", shell_output("#{bin}/has git")
    assert_match version.to_s, shell_output("#{bin}/has --version")
  end
end