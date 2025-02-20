class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https:www.apollographql.comdocsrover"
  url "https:github.comapollographqlroverarchiverefstagsv0.27.2.tar.gz"
  sha256 "afdaa5ab4d1afc3d1138a93aca207aa666e9d262e4a3484d352969420868e186"
  license "MIT"
  head "https:github.comapollographqlrover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "644b6aaabe5a07d17b60d486d84995b700cafc5c4ee15a4474f6da07061274a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bdd683d0abdd2d5b204ce66ee17c55d063149f22bedf9174097c33fc5d9541e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1a2d5d98f7884a211fe933f3cc16d7a8b83b096395d23e048b57e9ea0c73d1c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "adec5cc860f6bb0558aff3ca95ef202edcfb4d69809d7f66e4eb4a7f729aa593"
    sha256 cellar: :any_skip_relocation, ventura:       "d15e91441e7aab048401ba531b78e3872220ac0c9b3507a64d9e37b78b44cf69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50117a3e0f89677cbce619fbcfda3a3a643bc57e6a297fce796e79108bc6fd16"
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