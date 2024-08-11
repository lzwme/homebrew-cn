class EasyRsa < Formula
  desc "CLI utility to build and manage a PKI CA"
  homepage "https:github.comOpenVPNeasy-rsa"
  url "https:github.comOpenVPNeasy-rsareleasesdownloadv3.2.0EasyRSA-3.2.0.tgz"
  sha256 "db8164165a109bf1f6dbf578c3341349821bb4fde5629398d82918330134b43c"
  license "GPL-2.0-only"
  head "https:github.comOpenVPNeasy-rsa.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0c548341d3cf5900a1565f5c0464a082ed5f9f3c062025b97731804df0ef7a31"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0c548341d3cf5900a1565f5c0464a082ed5f9f3c062025b97731804df0ef7a31"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c548341d3cf5900a1565f5c0464a082ed5f9f3c062025b97731804df0ef7a31"
    sha256 cellar: :any_skip_relocation, sonoma:         "05a1c069fee5a14aef5bd45fd6a64f265197dc12671e3f7739b4403d26a36a10"
    sha256 cellar: :any_skip_relocation, ventura:        "05a1c069fee5a14aef5bd45fd6a64f265197dc12671e3f7739b4403d26a36a10"
    sha256 cellar: :any_skip_relocation, monterey:       "05a1c069fee5a14aef5bd45fd6a64f265197dc12671e3f7739b4403d26a36a10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c548341d3cf5900a1565f5c0464a082ed5f9f3c062025b97731804df0ef7a31"
  end

  depends_on "openssl@3"

  def install
    inreplace "easyrsa", "'etceasy-rsa'", "'#{pkgetc}'"
    libexec.install "easyrsa"
    (bin"easyrsa").write_env_script libexec"easyrsa",
      EASYRSA:         pkgetc,
      EASYRSA_OPENSSL: Formula["openssl@3"].opt_bin"openssl",
      EASYRSA_PKI:     "${EASYRSA_PKI:-#{etc}pki}"

    pkgetc.install %w[
      openssl-easyrsa.cnf
      x509-types
      vars.example
    ]

    doc.install %w[
      ChangeLog
      COPYING.md
      README.md
      README.quickstart.md
    ]

    doc.install Dir["doc*"]
  end

  def caveats
    <<~EOS
      By default, keys will be created in:
        #{etc}pki

      The configuration may be modified by editing and renaming:
        #{pkgetc}vars.example
    EOS
  end

  test do
    ENV["EASYRSA_PKI"] = testpath"pki"
    assert_match "'init-pki' complete; you may now create a CA or requests.",
      shell_output("#{bin}easyrsa init-pki")
  end
end