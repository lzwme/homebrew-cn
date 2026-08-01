class Librefang < Formula
  desc "Self-hostable operating system for autonomous AI agents"
  homepage "https://librefang.ai"
  url "https://ghfast.top/https://github.com/librefang/librefang/archive/refs/tags/v2026.7.31.tar.gz"
  sha256 "a72af257a64f3a5ebe8e418c2ef8d1c6455762d61f2e0b0473d12ea6680abafc"
  license "MIT"
  head "https://github.com/librefang/librefang.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "67418d7bcfbe1040812ab30ec8b16cece9f1330afb88369d95043f02e8f8fcb0"
    sha256 cellar: :any, arm64_sequoia: "80018fdd3ef1df21f1fbe5f4fb8087afdc3705728ab76337777ce5e11109086f"
    sha256 cellar: :any, arm64_sonoma:  "4d01abd103c052359790ca22e9f7eca8bb2a685ccaa20cf37367f43951d06853"
    sha256 cellar: :any, sonoma:        "859e30b3eb6eb499cf381822a75e0365e60af606c78bd66b064d80abf28f1e3d"
    sha256 cellar: :any, arm64_linux:   "ab04b282a1825ee1c9fffbdd3bc48490bb96f4a4b64a6d31be70eec135a4e150"
    sha256 cellar: :any, x86_64_linux:  "5fc99fad51a56e190a12fa3982634a93f66898c51865b027b4dfd33e8fefbf82"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "dbus"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/librefang-cli")
  end

  test do
    system bin/"librefang", "init", "--quick"
    assert_path_exists testpath/".librefang/config.toml"
  end
end