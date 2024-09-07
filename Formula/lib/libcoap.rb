class Libcoap < Formula
  desc "Lightweight application-protocol for resource-constrained devices"
  homepage "https:github.comobgmlibcoap"
  url "https:github.comobgmlibcoaparchiverefstagsv4.3.5.tar.gz"
  sha256 "a417ed26ec6c95c041b42353b5b6fad1602e2bf42a6e26c09863450e227b7b5f"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "adf74e75f33dddc9743b724da6448cac42e9d9669332117eedf66590fa1dd9d3"
    sha256 cellar: :any,                 arm64_ventura:  "6d39dc76cecd35963892f1aed2d9e7d66389d6c92a6fcab2c1dcaed985dafecb"
    sha256 cellar: :any,                 arm64_monterey: "2b4ba6f3f52e7168aa0d15dca716fe6d920f48414e4432f9b3de874334f0d992"
    sha256 cellar: :any,                 sonoma:         "fb9ecfcb47c75e493c096e3d2d9da010b10dfb335b5dd60a93fe49a6fb2830f5"
    sha256 cellar: :any,                 ventura:        "054787d4613fec89f6c5d3be9d36c2731197f1075b3f614315c3b14e4fd54c70"
    sha256 cellar: :any,                 monterey:       "d05b051c441b6d565bca208dd13ec7176efc5022b17c188828895425024c7cda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24b2cf100856f83699fa2e395f82ae26a730c8b5ff159aaea1b50167e1c137e5"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "doxygen" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@3"

  def install
    system ".autogen.sh"
    system ".configure", "--disable-examples", "--disable-manpages", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    %w[coap-client coap-server].each do |src|
      system ENV.cc, pkgshare"examples#{src}.c",
        "-I#{Formula["openssl@3"].opt_include}", "-I#{include}",
        "-L#{Formula["openssl@3"].opt_lib}", "-L#{lib}",
        "-lcrypto", "-lssl", "-lcoap-3-openssl", "-o", src
    end

    port = free_port
    fork do
      exec testpath"coap-server", "-p", port.to_s
    end

    sleep 1
    output = shell_output(testpath"coap-client -B 5 -m get coap:localhost:#{port}")
    assert_match "This is a test server made with libcoap", output
  end
end