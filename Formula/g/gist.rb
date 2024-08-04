class Gist < Formula
  desc "Command-line utility for uploading Gists"
  homepage "https:github.comdefunktgist"
  url "https:github.comdefunktgistarchiverefstagsv6.0.0.tar.gz"
  sha256 "ddfb33c039f8825506830448a658aa22685fc0c25dbe6d0240490982c4721812"
  license "MIT"
  head "https:github.comdefunktgist.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "8efc350b478d929ecf6de1f41afa0763fccf1efdeed3c16384deb5b4fb8bf66a"
  end

  uses_from_macos "ruby", since: :high_sierra

  def install
    system "rake", "install", "prefix=#{prefix}"
  end

  test do
    output = pipe_output(bin"gist", "homebrew")
    assert_match "GitHub now requires credentials", output
  end
end