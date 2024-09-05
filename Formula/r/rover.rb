class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https:www.apollographql.comdocsrover"
  url "https:github.comapollographqlroverarchiverefstagsv0.26.1.tar.gz"
  sha256 "568a271535f0bfcd4db02cc05d759b1e6a7a31eaed6a54d2939f85c359e9a39e"
  license "MIT"
  head "https:github.comapollographqlrover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a714f42735698f850c257dfeed55ec36025dc7d4034f3dfb5cc360c0af0783df"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f5c1d66b1b05282012e38fb15458ab4eafcb657d7eb8a5f45f3ee00ef0294c44"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aca2876efe87074931820394a94b4a4b762d14ca9bd159b98aa30cc613a2e84d"
    sha256 cellar: :any_skip_relocation, sonoma:         "05a5e9676169d564a9f9660a6ad63a71cfa16afd0f7d8e53be3ccc378fb1db0a"
    sha256 cellar: :any_skip_relocation, ventura:        "e89ec9a64a4eebd2eb8146af8cd0fb5a2e3565196626083b007f6a1dba2553e4"
    sha256 cellar: :any_skip_relocation, monterey:       "b41e29b75ad3d9b81feacefd137a0595065bc9c09de3303c5354c0cd9cd6157b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a1a520c1253b9898a1ff3edf28b43bbb3f5da8f2273ae844f865cba1aca6a61"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}rover graph introspect https:graphqlzero.almansi.meapi")
    assert_match "directive @specifiedBy", output

    assert_match version.to_s, shell_output("#{bin}rover --version")
  end
end