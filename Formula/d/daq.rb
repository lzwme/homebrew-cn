class Daq < Formula
  desc "Network intrusion prevention and detection system"
  homepage "https://www.snort.org/"
  url "https://ghfast.top/https://github.com/snort3/libdaq/archive/refs/tags/v3.0.25.tar.gz"
  mirror "https://fossies.org/linux/misc/libdaq-3.0.25.tar.gz"
  sha256 "651e38a2737d179a224bcb01d8a06300667708ee614d19a8b411fdd212cc035d"
  license "GPL-2.0-only"
  head "https://github.com/snort3/libdaq.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2e11fd98c54211c9ac800ccc4930849458f835797789f8c4006f677f3ea2096b"
    sha256 cellar: :any,                 arm64_sequoia: "e0a91451ab72d048f6ad8ceb775f158d9e32725d6500f9bf274b66d8d93a6052"
    sha256 cellar: :any,                 arm64_sonoma:  "19e26e225e7465a43288607dc642223a25c45dd52845f59045ac13a68d0c1c8c"
    sha256 cellar: :any,                 sonoma:        "909b71e0609cf82c7e1f92ba638be8fc764af989d4478d707b884db72327ff24"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83723eb2e51873cb9489a7906710eb99285b16060c88ad07e4e5883b6e6b23fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72b8898a3351bce7a6be9caa370b0cd3715466a1def695cef02e09d91e774acd"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  uses_from_macos "libpcap"

  def install
    system "./bootstrap"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <assert.h>
      #include <stdio.h>
      #include <daq.h>
      #include <daq_module_api.h>

      extern const DAQ_ModuleAPI_t pcap_daq_module_data;
      static DAQ_Module_h static_modules[] = { &pcap_daq_module_data, NULL };

      int main()
      {
        int rval = daq_load_static_modules(static_modules);
        assert(rval == 1);
        DAQ_Module_h module = daq_modules_first();
        assert(module != NULL);
        printf("[%s] - Type: 0x%x", daq_module_get_name(module), daq_module_get_type(module));
        module = daq_modules_next();
        assert(module == NULL);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-ldaq", "-ldaq_static_pcap", "-lpcap", "-lpthread", "-o", "test"
    assert_match "[pcap] - Type: 0xb", shell_output("./test")
  end
end