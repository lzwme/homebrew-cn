class Zsign < Formula
  desc "Cross-platform codesigning tool for iOS apps"
  homepage "https://github.com/zhlynn/zsign"
  url "https://ghfast.top/https://github.com/zhlynn/zsign/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "3ea97b5ff96b5e115757dfca969378c38682507282d30e2a4583b2a2264e65e7"
  license "MIT"
  head "https://github.com/zhlynn/zsign.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "69b6cbea96b12a6e42af80650fb3e2b99f1c812cd74b203c354da210b48e77c0"
    sha256 cellar: :any,                 arm64_sequoia: "66764ca15e0684eaa8eca50d29ba7e9ef4223b6f8be90c886b299c0fe539d35d"
    sha256 cellar: :any,                 arm64_sonoma:  "1607d3b1ecb6288d2bb0695125ff2b69629211cf57655b8066d9130df97165cd"
    sha256 cellar: :any,                 sonoma:        "2a3a5c6a5924f543f1c8b1dd80bf5f4d768777b4d0911523dff74dc287fd4f6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02cbc54a073b163e0d9adf396bfd028e0568ff415e45d0aa20a01c81645e66d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0aa7130b30d71609c5c84078e77e86cd510f146cbf51f2435e85f40f670ecf7"
  end

  depends_on "pkgconf" => :build
  depends_on "minizip-ng"
  depends_on "openssl@3"

  # Use minizip-ng in Linux Makefile, upstream PR: https://github.com/zhlynn/zsign/pull/386
  patch do
    url "https://github.com/zhlynn/zsign/commit/d4c32a6c877a62cf4b0b39dcefcd37e898f940b8.patch?full_index=1"
    sha256 "0d7e25f328016f2b5d21f67db07d300a0ff928a1d9aba213e8b9336b10013905"
  end

  def install
    build_dir = OS.mac? ? "build/macos" : "build/linux"
    system "make", "-C", build_dir, "CXX=#{ENV.cxx}"
    bin.install "bin/zsign"
  end

  test do
    (testpath/"fake.ipa").write "not a real ipa"
    output = shell_output("#{bin}/zsign #{testpath}/fake.ipa 2>&1", 255)
    assert_match "Invalid mach-o file", output
  end
end