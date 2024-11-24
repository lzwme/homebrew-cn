class RedwaxTool < Formula
  desc "Universal certificate conversion tool"
  homepage "https://redwax.eu/rt/"
  url "https://redwax.eu/dist/rt/redwax-tool-0.9.6.tar.bz2"
  sha256 "7409b13af278b8a69c8428e388d79ad1265136be177bd9083d84399aa4242edc"
  license "Apache-2.0"

  livecheck do
    url "https://redwax.eu/dist/rt/"
    regex(/href=.*?redwax-tool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "68d4c7a2ccfd9e7d6f1c5395fe149497eb9159dbc1854c80571d862e9a4da3f9"
    sha256 cellar: :any,                 arm64_sonoma:  "0655bc75c6619caf8ceeb4268695ff05619f8b41101496db08bb085d1cf9f0bd"
    sha256 cellar: :any,                 arm64_ventura: "0801f3e1ee4e843ee1bd56bb2c2f1fa4bb6a97d1c8d78f881c3f90899960f036"
    sha256 cellar: :any,                 sonoma:        "542baabe9c6267a58a3e07933972e478813c6bb506b46378dc03b23b09c572bc"
    sha256 cellar: :any,                 ventura:       "69ef5583d4389ea70ee734c490a66bb8cacd7578dea8d25955a7006f03bdded1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d5c0d21bc2469587576c4f1c97f65ab611e9e9f3deafa151d8dde7949ec12e3"
  end

  depends_on "pkgconf" => :build
  depends_on "apr"
  depends_on "apr-util"
  depends_on "openssl@3"

  uses_from_macos "expat"

  def install
    system "./configure", "--disable-silent-rules", "--with-openssl", *std_configure_args
    system "make", "install"
  end

  test do
    x509_args = {
      "C"            => "US",
      "ST"           => "Massachusetts",
      "L"            => "Boston",
      "O"            => "Homebrew",
      "OU"           => "Example",
      "CN"           => "User",
      "emailAddress" => "hello@example.com",
    }

    system "openssl", "req", "-x509", "-newkey", "rsa:4096", "-days", "1", "-nodes",
           "-keyout", "key.pem", "-out", "cert.pem", "-sha256",
           "-subj", "/#{(x509_args.map { |key, value| "#{key}=#{value}" }).join("/")}"

    args = %w[
      --pem-in key.pem
      --pem-in cert.pem
      --filter passthrough
      --pem-out combined.pem
    ]

    expected_outputs = [
      "pem-in: private key: OpenSSL RSA implementation",
      "pem-out: private key: OpenSSL RSA implementation",
      "pem-in: intermediate: #{(x509_args.map { |key, value| "#{key}=#{value}" }).reverse.join(",")}",
      "pem-out: intermediate: #{(x509_args.map { |key, value| "#{key}=#{value}" }).reverse.join(",")}",
    ]

    output = shell_output("#{bin}/redwax-tool #{args.join(" ")} 2>&1")

    expected_outputs.each do |s|
      assert_match s, output
    end

    assert_path_exists testpath/"combined.pem"
  end
end