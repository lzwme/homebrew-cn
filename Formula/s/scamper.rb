class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/catalog/software/scamper/"
  url "https://www.caida.org/catalog/software/scamper/code/scamper-cvs-20240117.tar.gz"
  sha256 "dd3203ddcba6192160c40aeaab1aee6ce35da7f2516b34a12117f51dda622562"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.caida.org/catalog/software/scamper/code/?C=M&O=D"
    regex(/href=.*?scamper(?:-cvs)?[._-]v?(\d{6,8}[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bd20d6ee1e3b1c76ac4d2708b6b2deaac354baedf8322f2de9336eeb337d8324"
    sha256 cellar: :any,                 arm64_ventura:  "b53a3f02152340e3f5c2ec9be719564694d44870c968dde231a4c382ccc7e0d8"
    sha256 cellar: :any,                 arm64_monterey: "9acd2c2a039b78121cbe944aa1019c7390ed7653ee3818bf5d04e562732c0572"
    sha256 cellar: :any,                 sonoma:         "de1c78663ee573187170e7470d9dad7467dde43c5bee33fb9c659bdd03d7613a"
    sha256 cellar: :any,                 ventura:        "f8f613aeae01b8508b2100a26bb697ace95d2127310ca21d72183eedb7f831af"
    sha256 cellar: :any,                 monterey:       "3ab8386357e6edd90b3b31d711d29971bee0db992483e048c7285a541f4f8720"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e795f8c9025f245bb677a5446a5f376e0e25a636ad547ad0c93bbcc0951815f"
  end

  depends_on "pkg-config" => :build
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