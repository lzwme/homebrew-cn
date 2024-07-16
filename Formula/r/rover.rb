class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https:www.apollographql.comdocsrover"
  url "https:github.comapollographqlroverarchiverefstagsv0.24.0.tar.gz"
  sha256 "f335250bbb70baf0aca24faab06ff136dfc4a269eb5869f12d97408ed183b059"
  license "MIT"
  head "https:github.comapollographqlrover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b092e532bb12e78aa3e125776ac7ae4af28a94d64b191a08002da030522b0565"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e209ad3c990fad71618ee83c70bd5a8828d6fbb9a527f822ffa8425ac7a0a98"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a4e5ff6c08a832e6b7b41da457874eb8a20da43ec6fdf585455af4393fadb23"
    sha256 cellar: :any_skip_relocation, sonoma:         "8d60d5f6f5de351711fc6015830fb06bcaffc9b551cde2d9954d0cf50dd1d83b"
    sha256 cellar: :any_skip_relocation, ventura:        "4f59968b8fff7a0927098f50d223dc8a85a11e32901215f96f49e690cbca8c77"
    sha256 cellar: :any_skip_relocation, monterey:       "a802b549de6d5db543a3f1c351d259ac189de081d26692d6a17a48073b452012"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "657144bb2271bbc0e27ec8b2aed08278a9400b4ab41e2efe7a78af1a07798fc5"
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