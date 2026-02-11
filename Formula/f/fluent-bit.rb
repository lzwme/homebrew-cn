class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://ghfast.top/https://github.com/fluent/fluent-bit/archive/refs/tags/v4.2.2.tar.gz"
  sha256 "5d8e642be576985ad8123609c32d5ac44a9d3dad9eafcdc14208622444b5a4f0"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "3adf65a9576fbea4dfcbf159abfce1cbfd6a32dd52ebca23d4c4927d65a1cda5"
    sha256 cellar: :any,                 arm64_sequoia: "74f91e8e1b52686a74c7e33f2818f0e28e3a1003d6e133a74e9cd18cf30f209e"
    sha256 cellar: :any,                 arm64_sonoma:  "b2f7b84102140b41b596aee2a3807cdaa529e0a5151d79107328cc15e195d6b8"
    sha256 cellar: :any,                 sonoma:        "52e8cb3397bbce6b21889aad864996e367e77c32d80b39b17d4d1a2ca290f76a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6cbe451fe2323b0fe5f7dd438761ff7ea4c2f6ccb81967ccc626126c778c3a9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1dde513b2295154465d13ab6c9ac89d61c24a4698a656312abd5c49bf3cbcf8"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "pkgconf" => :build

  depends_on "libyaml"
  depends_on "luajit"
  depends_on "openssl@3"

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