class Daq < Formula
  desc "Network intrusion prevention and detection system"
  homepage "https:www.snort.org"
  url "https:github.comsnort3libdaqarchiverefstagsv3.0.13.tar.gz"
  mirror "https:fossies.orglinuxmisclibdaq-3.0.13.tar.gz"
  sha256 "3a48b934bc45a1fe44b3887185d33a76a042c1d10aa177e3e7c417d83da67213"
  license "GPL-2.0-only"
  head "https:github.comsnort3libdaq.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f726274fc78e8ff3e60cbc5e97656163d51732445a442307cc9fa567385e5d6d"
    sha256 cellar: :any,                 arm64_ventura:  "02a21711c3b93977e11ff99a6d806fdd6f7f6db5ffb9c4590df576f6a9729680"
    sha256 cellar: :any,                 arm64_monterey: "f71de79cc4597c236aa55f438e729613dd82581dfdb5c2d0a9e1728c4e63ee84"
    sha256 cellar: :any,                 sonoma:         "62a22e7946d1dd0992ec608ac7fa7343725e6dd085b022f462393d054fdcdfbd"
    sha256 cellar: :any,                 ventura:        "e3bdcf2b9ba5e8552993a8a5415b620116cb4829354eeffe1f1f09321dcd6702"
    sha256 cellar: :any,                 monterey:       "a9ead17132adc51045609fe171ae8330d574b14b57092fb679be6b37aee8a82f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d6e525611b08b6f2b80081f6c5ae6576e1d9f22edd453b78a139738cc9077f6"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  uses_from_macos "libpcap"

  def install
    system ".bootstrap"
    system ".configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    (testpath"test.c").write <<~EOS
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
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-ldaq", "-ldaq_static_pcap", "-lpcap", "-lpthread", "-o", "test"
    assert_match "[pcap] - Type: 0xb", shell_output(".test")
  end
end