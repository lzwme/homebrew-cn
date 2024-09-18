class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/catalog/software/scamper/"
  url "https://www.caida.org/catalog/software/scamper/code/scamper-cvs-20240916.tar.gz"
  sha256 "fdb6b83dda79245cfbc79a05467d41394a354aa74c12bf5514435808440eaac5"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.caida.org/catalog/software/scamper/code/?C=M&O=D"
    regex(/href=.*?scamper(?:-cvs)?[._-]v?(\d{6,8}[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5d8206ba8e6b5e5ceba1858b4e3f25782c46f00e8cad02115b8a2532fec05142"
    sha256 cellar: :any,                 arm64_sonoma:  "ab30c080cc47a07d183a3d1849ff8621410b8404329d52a037fed99305c484d6"
    sha256 cellar: :any,                 arm64_ventura: "ce16df32b7efb9f06d7de8cfeedb4e4329ad830e257da7bce214ee706ac98694"
    sha256 cellar: :any,                 sonoma:        "1a36c96a183a7e5754a51329eb4851e1ee5580200ee08b066c83f43abc307a3b"
    sha256 cellar: :any,                 ventura:       "597a7edaa5e14017189c1accc3398353e317da6886eec5c200ce78012f8a539f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9bb129f6d8911a8bacc7d6c7d81ee48ca64920fe46066e54254af8b8f0e9574"
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