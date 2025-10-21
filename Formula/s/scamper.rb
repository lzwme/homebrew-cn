class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/catalog/software/scamper/"
  url "https://www.caida.org/catalog/software/scamper/code/scamper-cvs-20251020.tar.gz"
  sha256 "6ef4d8d22c8cb3a4cc0391955d1a6c5f2c8e16f510c434f5cb9e9395676fcccd"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.caida.org/catalog/software/scamper/code/?C=M&O=D"
    regex(/href=.*?scamper(?:-cvs)?[._-]v?(\d{6,8}[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a772e111410c65dc300c615c7bad5c498e7e39ef4991df88c40b1c74bcc24cd2"
    sha256 cellar: :any,                 arm64_sequoia: "22d81a414f7f209fec07f3139737050e7b8b42725882ce7c32dae88e314877e6"
    sha256 cellar: :any,                 arm64_sonoma:  "5ed587879553f48deb7ae75733309bd64dbc32c6f795b6286f233cfc88a62616"
    sha256 cellar: :any,                 sonoma:        "abe420ed8e127f3e02a1d73f817887cf35f499c3951dccf5e0040ecd6f820c3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a14124b7f88578229b42151cb7aee1b076442d7084826018c1ffa1e7f13760a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba1477cedb416fce90dfec8d150c8562a4dff5ad3588365d2b7c28e28f1d3cc5"
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@3"
  depends_on "xz" # for LZMA

  uses_from_macos "zlib"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    expected = if OS.mac?
      "dl_bpf_open_dev"
    else
      "scamper_privsep_init"
    end
    assert_match expected, shell_output("#{bin}/scamper -i 127.0.0.1 2>&1", 255)
    assert_match version.to_s, shell_output("#{bin}/scamper -v")
  end
end