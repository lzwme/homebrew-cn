class S3Backer < Formula
  desc "FUSE-based single file backing store via Amazon S3"
  homepage "https:github.comarchiecobbss3backer"
  # Release distributions listed at https:github.comarchiecobbss3backerwikiDownloads
  url "https:s3.amazonaws.comarchie-publics3backers3backer-2.1.4.tar.gz"
  sha256 "0451471209cc872708e91b2784a4a1b9f3ca44c89a7bffb8f6145aed28c941e7"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "54509b12da98f4375896e2914a44162745f0d629163de99578080af5976bbf34"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0e0cff205bf0b253dc8dfc5127acf9db4375fc92d1d076750261c547d6eefc2f"
  end

  depends_on "pkgconf" => :build
  depends_on "curl"
  depends_on "expat"
  depends_on "libfuse@2"
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "openssl@3"
  depends_on "zlib"
  depends_on "zstd"

  def install
    system ".configure", "--disable-silent-rules",
            *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}s3backer --version 2>&1")

    assert_match "no S3 bucket specified", shell_output("#{bin}s3backer 2>&1", 1)
  end
end