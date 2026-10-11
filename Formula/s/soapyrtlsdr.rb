class Soapyrtlsdr < Formula
  desc "SoapySDR RTL-SDR Support Module"
  homepage "https://github.com/pothosware/SoapyRTLSDR/wiki"
  url "https://ghfast.top/https://github.com/pothosware/SoapyRTLSDR/archive/refs/tags/soapy-rtl-sdr-0.3.3.tar.gz"
  sha256 "757c3c3bd17c5a12c7168db2f2f0fd274457e65f35e23c5ec9aec34e3ef54ece"
  license "MIT"
  revision 3
  head "https://github.com/pothosware/SoapyRTLSDR.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6b8c88d60409fbc233955a162c565e41a773406c15a62868f893be62445606a6"
    sha256 cellar: :any, arm64_tahoe:       "7253b0c4ebbbdcbea232179d096dde12345147204f10507f6cc97ca628a040e5"
    sha256 cellar: :any, arm64_sequoia:     "34424db2bd5373cb465ca85223741d84584bb5ad6503b88d0256b7b963f6f1e9"
    sha256 cellar: :any, arm64_linux:       "fbc1e76a6ad2dc14656676d88e085bbf3ad406aba753694c22cce05bc188456f"
    sha256 cellar: :any, x86_64_linux:      "06df94d9559d5dab8da052200d0416ea1f34f7642d31166316c580b42332622f"
  end

  depends_on "cmake" => :build
  depends_on "librtlsdr"
  depends_on "soapysdr"

  deny_network_access!

  def install
    # Workaround to build with CMake 4
    args = %w[-DCMAKE_POLICY_VERSION_MINIMUM=3.5]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{formula_opt_bin("soapysdr")}/SoapySDRUtil --check=rtlsdr")
    assert_match "Checking driver 'rtlsdr'... PRESENT", output
  end
end