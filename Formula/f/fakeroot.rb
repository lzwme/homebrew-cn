class Fakeroot < Formula
  desc "Provide a fake root environment"
  homepage "https://tracker.debian.org/pkg/fakeroot"
  url "https://deb.debian.org/debian/pool/main/f/fakeroot/fakeroot_1.38.orig.tar.gz"
  sha256 "37504619270923546f36d98107f44a3c3be41c8ccd57dfd722311819623fe002"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/f/fakeroot/"
    regex(/href=.*?fakeroot[._-]v?(\d+(?:\.\d+)+)[._-]orig\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9d2b0242f4612306919b19c2ee463fde14495144d70329b0aa82d67a3f19c3e9"
    sha256 cellar: :any,                 arm64_sequoia: "7bc64eaaf6b80bd54d220e12dbd2f1b487e667325879e3e6f38c0651c1e04a78"
    sha256 cellar: :any,                 arm64_sonoma:  "3296bf87a1e7fa0bd694b74942e994ad852d6d0f43a420d72049176c54b0e2f5"
    sha256 cellar: :any,                 sonoma:        "0aa3e7aeb3ae0480e04a6c2bac7777363c9119283b48bdd0351b4e8882e19a95"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d75d7233964210958a50890ed027f53d64e7e7b4a9fcf70b873221a57676863"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93e29b0bdd38508e50e48273f1c784d363a1890a01e2198fedb2e04ad908c85f"
  end

  on_linux do
    depends_on "libcap" => :build
  end

  def install
    args = ["--disable-silent-rules"]
    args << "--disable-static" if OS.mac?

    system "./configure", *args, *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fakeroot -v")
  end
end