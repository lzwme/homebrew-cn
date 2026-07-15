class Zsign < Formula
  desc "Cross-platform codesigning tool for iOS apps"
  homepage "https://github.com/zhlynn/zsign"
  url "https://ghfast.top/https://github.com/zhlynn/zsign/archive/refs/tags/v1.0.9.tar.gz"
  sha256 "d2fb8dc6d5460aa41af26bb5acf6b893a262913494b70be5268b5e734f5462a5"
  license "MIT"
  head "https://github.com/zhlynn/zsign.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d7584e2f4f07f9d525bb3ea616c24ca5818aadbde5edc0b14fa3647bcd2e6912"
    sha256 cellar: :any, arm64_sequoia: "c7ccba56d2ae4470251a9c048e009212308a7f46fb99b2000949d4c0dcdf9f7a"
    sha256 cellar: :any, arm64_sonoma:  "c0b9a53d515888bbef698a6149e5a6f0d9c6478fc9b22fe64c766b85f5929709"
    sha256 cellar: :any, sonoma:        "3dbdd9ce9b3d0f73f0794c6c7ea9115b575e73b34f8ca99f3f8e118edf8e33c5"
    sha256 cellar: :any, arm64_linux:   "e4e054ea15f442e00a2adbe7012811fa02012f0b56449ede11eb343185ca3926"
    sha256 cellar: :any, x86_64_linux:  "6dbc504906c76da4ab984ed194300e7f2e8ff5e5586fbd683ae5e9a155248760"
  end

  depends_on "pkgconf" => :build
  depends_on "minizip-ng"
  depends_on "openssl@4"

  def install
    build_dir = OS.mac? ? "build/macos" : "build/linux"
    system "make", "-C", build_dir, "CXX=#{ENV.cxx}", "VERSION=#{version}", "SYSTEM_MINIZIP=ng"
    bin.install "bin/zsign"
  end

  test do
    (testpath/"fake.ipa").write "not a real ipa"
    output = shell_output("#{bin}/zsign #{testpath}/fake.ipa 2>&1", 255)
    assert_match "Invalid mach-o file", output
  end
end