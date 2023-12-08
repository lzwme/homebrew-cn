class Noir < Formula
  desc "Attack surface detector that identifies endpoints by static analysis"
  homepage "https://github.com/noir-cr/noir"
  url "https://ghproxy.com/https://github.com/noir-cr/noir/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "37b0b78d4673cc2482ad346010de8b36be5f75c92724938aa6e2ec1fd1883e20"
  license "MIT"

  bottle do
    sha256 arm64_sonoma:   "485206f0e38ee88b92b31a829ed1d1eac86bd56ca1020ba113fb232af86b76c6"
    sha256 arm64_ventura:  "768eea0ecbe04d12e7a9784d4f826a265ae45f6a35262358fc5a8dbc5cd0a22d"
    sha256 arm64_monterey: "a848b92d90aac9576de6030859ec52dae0ef457ce443829fcb16d04d8f8df9a8"
    sha256 sonoma:         "6402b1e4ce537772af92ab41d34fb3e3ad5fb52e740b4435c8ad5882e6c71dc6"
    sha256 ventura:        "08b6ddd4c8eceaae84a257b17094f3258df8ce30cd6086bd8fb55471a74b3895"
    sha256 monterey:       "7907f5cda5c58bb022957b3ec67d1d10fc7e5fc1acd5d927628531f5a194131d"
    sha256 x86_64_linux:   "18e742d134e891620565032264dd3453f2294f91f426a8a002f087858221fa66"
  end

  depends_on "crystal"

  def install
    system "shards", "install"
    system "shards", "build", "--release", "--no-debug"
    bin.install "bin/noir"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/noir --version")

    system "git", "clone", "https://github.com/noir-cr/noir.git"
    output = shell_output("#{bin}/noir -b noir 2>&1")
    assert_match "Generating Report.", output
  end
end