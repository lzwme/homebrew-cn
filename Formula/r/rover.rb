class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https:www.apollographql.comdocsrover"
  url "https:github.comapollographqlroverarchiverefstagsv0.34.0.tar.gz"
  sha256 "edbcb43f35d6ea3c9e39fa5fb808d4f568eed4c86ac805f2c650e85069f12559"
  license "MIT"
  head "https:github.comapollographqlrover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75028e5170c644a0c4e685c21b7b2e76d36da1724a0161f79d2758a30e2402e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b578e6f66af2fa02cb077ecb1a25c474300bf555a6f0894f71e0072dc1956455"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1f0699437c672f7a2daee9a6fc7fd1f7004e12741b090b2882eed141f853befd"
    sha256 cellar: :any_skip_relocation, sonoma:        "438dbd38631f8302551d58a1b545b691bbc2981b544475f1fba1396705bd532b"
    sha256 cellar: :any_skip_relocation, ventura:       "e94cb9425b30e563d1a1414f7bd1d277da54bfa96ad4c39a3d58e9bf0496d200"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8417c3a1f85a0412858de3a6ee0de0dcb030f3c30c891a3cfccde10ec7497fd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63851c0005531aacd47fdfb06a0a730dd2d7e6bf5ac5841c34d60935aaef3b9d"
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