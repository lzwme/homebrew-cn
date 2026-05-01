class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://ghfast.top/https://github.com/fluent/fluent-bit/archive/refs/tags/v5.0.3.tar.gz"
  sha256 "74d5b348a17dffd9550600c59b9887f27638903627fdbfc8ed23878580f57b9b"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "837efe1c0d1e128ca41a20d9f8f4868c336cc4fa71c71009e2eb807bec866efd"
    sha256 cellar: :any,                 arm64_sequoia: "bbd682af7b3ef939a5bd4fa0c408c5cc271c32d8ee8c2f2fd8a7f402b4ea1bfe"
    sha256 cellar: :any,                 arm64_sonoma:  "7995fc9824857fb8b72567d889a498d90d87226fe853c3dbbf043ad78c819c5d"
    sha256 cellar: :any,                 sonoma:        "b40abbf04ff2701c422e6a24ccdd969c205ddcc92713ab1a00dd507e71414d56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d36079845ed07d93ae857e2e0b99fdd829924d94628fc123613fb6d55497deb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8de1193049340b7381622aceb3fe0c7c1a1d998bb3887446a35ff8ccc98a93dd"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "pkgconf" => :build

  depends_on "libyaml"
  depends_on "luajit"
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Prevent fluent-bit to install files into global init system
    # For more information see https://github.com/fluent/fluent-bit/issues/3393
    inreplace "src/CMakeLists.txt", "if(NOT SYSTEMD_UNITDIR AND IS_DIRECTORY /lib/systemd/system)", "if(False)"
    inreplace "src/CMakeLists.txt", "elseif(IS_DIRECTORY /usr/share/upstart)", "elif(False)"

    args = %w[
      -DFLB_PREFER_SYSTEM_LIB_LUAJIT=ON
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}/fluent-bit -V").chomp
    assert_match "Fluent Bit v#{version}", output
  end
end