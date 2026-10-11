class Soapysdr < Formula
  desc "Vendor and platform neutral SDR support library"
  homepage "https://github.com/pothosware/SoapySDR/wiki"
  url "https://ghfast.top/https://github.com/pothosware/SoapySDR/archive/refs/tags/soapy-sdr-0.9.0.tar.gz"
  sha256 "64f97c1ad241156fe299acb8902169019eab34517cd580b563968a43d7533509"
  license "BSL-1.0"
  compatibility_version 1
  head "https://github.com/pothosware/SoapySDR.git", branch: "master"

  bottle do
    sha256               arm64_golden_gate: "3469254e475fe092bdecc175945e7cc4ff34d85467f3b0b2e6251102e99607e1"
    sha256               arm64_tahoe:       "fba3e96fa13388d32a5cc49143bf70759155a0a13c9e49b5868337c4e99e65d8"
    sha256               arm64_sequoia:     "b8358cb10b130a3049118b94ff30d34e8009bf3e254d83ecf334fb67cf9660ff"
    sha256               arm64_linux:       "27fd6309c60ae3e93a0b6f4021f9305ec4ddd437cc2680fbb0b729f5206753fa"
    sha256 cellar: :any, x86_64_linux:      "bfff74ca26f2f85dfe71381ffa8df93b0324e666ff4d2428dad6cfc1d2bc3765"
  end

  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "python@3.14"

  deny_network_access!

  def install
    args = %W[
      -DPython3_EXECUTABLE=#{python3}
      -DSOAPY_SDR_ROOT=#{HOMEBREW_PREFIX}
    ]
    args << "-DSOAPY_SDR_EXTVER=release" if build.stable?

    site_packages = prefix/Language::Python.site_packages(python3)
    args << "-DCMAKE_INSTALL_RPATH=#{rpath};#{rpath(source: site_packages)}" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "Loading modules... done", shell_output("#{bin}/SoapySDRUtil --check=null")
    system python3, "-c", "import SoapySDR"
  end
end