class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://ghproxy.com/https://github.com/fluent/fluent-bit/archive/v2.1.0.tar.gz"
  sha256 "5d59b86919613e63f6f7a890764a12b13565f26552173244d4ad82e0ecec632f"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_ventura:  "ccaf66670b639d4d27c8c5d3613c649ff60ae0fe04c9ef254936011969243780"
    sha256 arm64_monterey: "6afd42f2b40b1b666a40e6a8a75b06572dc23443c204e1972b3e11f146bec080"
    sha256 arm64_big_sur:  "4f669e2729243d6aea4b9e1b8dd1ff81ab79848744f1f82ff8f11eb172147fe3"
    sha256 ventura:        "38449943ab9aa26a23f854d9b9c7eadddba530b92914d1d26643055003ed5f15"
    sha256 monterey:       "4e8369cfabc7de9f32eaf15c474dd1dda5796794287850789a7f05d2d54d6e19"
    sha256 big_sur:        "5910b40dbbafa8abd23313c11a1b864bc35b724a44626a763bde4c9ee391450a"
    sha256 x86_64_linux:   "c6e11b6f9ed634286c67cafe061cc80e516bbf02149f79d2a62c72234854e955"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "pkg-config" => :build

  depends_on "libyaml"
  depends_on "openssl@3"

  def install
    # Prevent fluent-bit to install files into global init system
    # For more information see https://github.com/fluent/fluent-bit/issues/3393
    inreplace "src/CMakeLists.txt", "if(NOT SYSTEMD_UNITDIR AND IS_DIRECTORY /lib/systemd/system)", "if(False)"
    inreplace "src/CMakeLists.txt", "elseif(IS_DIRECTORY /usr/share/upstart)", "elif(False)"

    # Per https://luajit.org/install.html: If MACOSX_DEPLOYMENT_TARGET
    # is not set then it's forced to 10.4, which breaks compile on Mojave.
    # fluent-bit builds against a vendored Luajit.
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}/fluent-bit -V").chomp
    assert_match "Fluent Bit v#{version}", output
  end
end