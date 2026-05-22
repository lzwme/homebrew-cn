class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://ghfast.top/https://github.com/fluent/fluent-bit/archive/refs/tags/v5.0.6.tar.gz"
  sha256 "bffe424e9010e89f412fbc0bbd054040aa4f447b9f2f20ffd5b42110db9b2fa3"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "605c58fac9b375951bbea871e540331806cc146d735364e9b083e521a111dcb8"
    sha256 cellar: :any,                 arm64_sequoia: "5993d3c5cda43bddf7fb21d63af07d7d116871ba576e3eeb4e54087d6709f74a"
    sha256 cellar: :any,                 arm64_sonoma:  "f4b4fd4b196706f4b910ffcde4b65ddce0860d7bfb8a0b2d82374b7bef596e5f"
    sha256 cellar: :any,                 sonoma:        "673cb1457a9b71f57c6185503b9664357052ef5c2ceb1386e93b0aba75396dc6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3788354aaaa38e103d9e02b261a47bd5578541bc5470a72c0214d0067e5ff706"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7c555f9335b6e4e21595b9f398dd4c1688c5a48f4d34121d7f68ff46cfecfdf"
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