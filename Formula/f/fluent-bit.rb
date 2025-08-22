class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://ghfast.top/https://github.com/fluent/fluent-bit/archive/refs/tags/v4.0.8.tar.gz"
  sha256 "ed7037bf9352f962adba1c5c9be148bd955c72d93b40b6010704b0067461b0d0"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b9a71a4c313aaf9c9a8ace76266c664d6278252530bb5dc288ee13b51ba30c41"
    sha256 cellar: :any,                 arm64_sonoma:  "dca7ca3fcb71dd9ffe916513455dd867e8cb1884c7ab211f183d25a3b8008983"
    sha256 cellar: :any,                 arm64_ventura: "bef5248e792c77fbcd669843967a8ef3612d54cd2c0e74059f1493e4a21ecf40"
    sha256 cellar: :any,                 sonoma:        "18283955811b93152fdd946edb4ba0a5cd5ec00872b338ebfbb020841c6e4688"
    sha256 cellar: :any,                 ventura:       "e407c26a5ba097fc5dfd7a4a57880ec91f8045ea64b8336c53227aa97df3236b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e302e4c299a0f477dac6a98a628ef2b29b21e87f9e659228df25644a814df2e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38d1a51427fb60d21737924d9dad77e7e32b2917e204aae8d7f414a18059719f"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "pkgconf" => :build

  depends_on "libyaml"
  depends_on "luajit"
  depends_on "openssl@3"
  uses_from_macos "zlib"

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