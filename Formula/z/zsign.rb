class Zsign < Formula
  desc "Cross-platform codesigning tool for iOS apps"
  homepage "https://github.com/zhlynn/zsign"
  url "https://ghfast.top/https://github.com/zhlynn/zsign/archive/refs/tags/v0.9.9.tar.gz"
  sha256 "530252e5ae7df80e0ac84e9a9fac4f2529ef383d9816343c0bff9fc6e2c30ae8"
  license "MIT"
  head "https://github.com/zhlynn/zsign.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "76583aae3de3b1390cd89155b2c58e799b623eec7cf8e9dec9a60db8922cb36f"
    sha256 cellar: :any,                 arm64_sequoia: "67949bf4c3844e6f304f0c20e4a818ce6fa3e99da6ae803e7def7e113dc29e1b"
    sha256 cellar: :any,                 arm64_sonoma:  "402a83a4ec47777f58d208e16cd06da6ef28fd1f22ce5cc0fea474e5685b592b"
    sha256 cellar: :any,                 sonoma:        "3a113b98c9c54d37aea02eeb68b12ed1324a956fa841a2dda0c20ed9fb37e849"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc8673d16d8419c4ce1f67130c00f6bbbbe365df91a77d3d1ff63338f0f91ae5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ff381d5c8e12dfef0e6e03a1ea9dcc81b61236f58e4a13b4d1b2d6858f3f8b4"
  end

  depends_on "pkgconf" => :build
  depends_on "minizip"
  depends_on "openssl@3"

  def install
    build_dir = OS.mac? ? "build/macos" : "build/linux"
    # Makefile hardcodes CXX=g++
    args = ["-C", build_dir, "CXX=#{ENV.cxx}"]

    if OS.linux?
      # zsign messes up the zip include path on Linux
      args << "CXXFLAGS=-std=c++11 -O3 -Wno-unused-result -I#{Formula["minizip"].opt_include}/minizip"
    end

    system "make", *args
    bin.install "bin/zsign"
  end

  test do
    (testpath/"fake.ipa").write "not a real ipa"
    output = shell_output("#{bin}/zsign #{testpath}/fake.ipa 2>&1", 255)
    assert_match "Invalid mach-o file", output
  end
end