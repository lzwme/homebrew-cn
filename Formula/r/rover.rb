class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https:www.apollographql.comdocsrover"
  url "https:github.comapollographqlroverarchiverefstagsv0.31.1.tar.gz"
  sha256 "386537e0161d7ae0745788a9313cf4723f09a0526ea66416356787636a5e927b"
  license "MIT"
  head "https:github.comapollographqlrover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eec44c2f292f25fbc190d01550305fcf36287da0b0cc168e790662fb4acf3041"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a710aa93a90b7e77ecec827f6ab4e8ef97ebe9cff7bafed774b2080b22203a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1ebbf4ab0ab56070ddc0f48d440e5cfa6f30479de1d88a72825a2f7d04910bf0"
    sha256 cellar: :any_skip_relocation, sonoma:        "19501000e8e6cf68eb5e823dac7b3dc9dabb170c887b2b1ebb65a4527f897819"
    sha256 cellar: :any_skip_relocation, ventura:       "a82aa8a6f9d5d40959e7d27949d808f05f5b093cb78d72e15d9f2432aaa78100"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "336fed8cecb7f45515b4495e48b8f694fe7f302371edc86f51e819b9b903f612"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47a627e6f636b44b686d8871b5028aea9994f79f1de84c8f8eca06f5327a60eb"
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