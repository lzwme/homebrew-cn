class AprUtil < Formula
  desc "Companion library to apr, the Apache Portable Runtime library"
  homepage "https://apr.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=apr/apr-util-1.6.4.tar.bz2"
  mirror "https://archive.apache.org/dist/apr/apr-util-1.6.4.tar.bz2"
  sha256 "3e2ae08f40efa0c3701e54a954cefa08242de22a69f91a8ae44fc1e624ba309b"
  license "Apache-2.0"

  bottle do
    sha256 arm64_tahoe:   "82a57ae679850ef087414651c874096a185e6b97209f0f7d2a7c4a9c5c11b892"
    sha256 arm64_sequoia: "bdf0e5f74bde191a1c8588363f5fcdb5b16d88e7438f12eca385fb87370245b1"
    sha256 arm64_sonoma:  "81aeb91f385ef6177e96a838296b4a9a77383cd23539d30104fabc0eab967f13"
    sha256 sonoma:        "e72b01fe543bf27ee642a6748c1376e6cfe8e7ba576855a1c62eabac29aa77ed"
    sha256 arm64_linux:   "6cf3eb8f71d0412736f132f5ab9c5a9d868e162d461b233e4d72c0079105c956"
    sha256 x86_64_linux:  "4eb33212b91b74f932564752048583de1b76476b19953e8ef1a7ce04806f069c"
  end

  keg_only :shadowed_by_macos, "Apple's CLT provides apr (but not apr-util)"

  depends_on "apr"
  depends_on "openssl@3"

  uses_from_macos "expat"
  uses_from_macos "libxcrypt"
  uses_from_macos "sqlite"

  on_linux do
    depends_on "unixodbc"
  end

  def install
    system "./configure", "--with-apr=#{formula_opt_prefix("apr")}",
                          "--with-crypto",
                          "--with-openssl=#{formula_opt_prefix("openssl@3")}",
                          "--without-pgsql",
                          *std_configure_args
    system "make"
    system "make", "install"

    # Install symlinks so that linkage doesn't break for reverse dependencies.
    # This should be removed on the next ABI breaking update.
    (libexec/"lib").install_symlink Dir["#{lib}/#{shared_library("*")}"]

    rm Dir[lib/"**/*.{la,exp}"]

    # No need for this to point to the versioned path.
    inreplace bin/"apu-#{version.major}-config", prefix, opt_prefix
  end

  test do
    assert_match opt_prefix.to_s, shell_output("#{bin}/apu-#{version.major}-config --prefix")
  end
end