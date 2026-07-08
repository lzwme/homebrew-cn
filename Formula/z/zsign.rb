class Zsign < Formula
  desc "Cross-platform codesigning tool for iOS apps"
  homepage "https://github.com/zhlynn/zsign"
  url "https://ghfast.top/https://github.com/zhlynn/zsign/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "84cc3458da2366f88cb87da87ddeed9c0a903c716d2a891aa09cc14e0a74b7ac"
  license "MIT"
  head "https://github.com/zhlynn/zsign.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6eaf659241a2a0f56398f68db82ffd856897f1acb9bf7cf09171c51b45b9ec25"
    sha256 cellar: :any, arm64_sequoia: "a4d296b7442a976a83e798a08611bdc3e8879dcbf02141c6583920ed1fa7a511"
    sha256 cellar: :any, arm64_sonoma:  "4f5f564cdf08f2a6844da216ad5fc25a908f740e2c3f746b15edec41b63153c8"
    sha256 cellar: :any, sonoma:        "849db49f21a50fe77f5a0173f7acde25c39b750a7639816a7e149b05bd98eb65"
    sha256 cellar: :any, arm64_linux:   "dd14f2972b65c373632721fb07c3f28e1b1b69e5a0007b4f00025b3d6fc9f897"
    sha256 cellar: :any, x86_64_linux:  "c1ba504d892b70bd48bf67b86f89b813361785e209e5fa4870fafd3367801e07"
  end

  depends_on "pkgconf" => :build
  depends_on "minizip-ng"
  depends_on "openssl@4"

  # Build against OpenSSL 4's const-correct X509/ASN1 accessors.
  # PR ref: https://github.com/zhlynn/zsign/pull/400
  patch do
    url "https://github.com/zhlynn/zsign/commit/c39607e4231bceffc0e4d7c1dc257ef67dd3c5b7.patch?full_index=1"
    sha256 "dda8e0a6308cbeb8190f349ffb8009e887c9c1053b2a30d1bcb78ee3d6e57d8c"
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