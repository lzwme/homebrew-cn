class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https:www.apollographql.comdocsrover"
  url "https:github.comapollographqlroverarchiverefstagsv0.30.0.tar.gz"
  sha256 "009e40675a057dceed38f9c80da63a4b1c73377345fc1eb74aff97d814532a1e"
  license "MIT"
  head "https:github.comapollographqlrover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5e4d3f0c2e539d36ca8024256e5dc1b8c3b731029665aeca6d20a690b0055da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "913324f5229cdf80016038d417b47c7fba79bdc88c8b569259face8b484dfca8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3f6d29452f0bd8be47ee15e296608a03995cf659d5febeddd3658561fc54e166"
    sha256 cellar: :any_skip_relocation, sonoma:        "877873455ecfc85b0c7f64a0ec3d1ea3e41e99482dda0052722a1d9f5025042a"
    sha256 cellar: :any_skip_relocation, ventura:       "c96681d67269607ef428823e304bb1e003cd24d0e64809161824753bd309915d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "150bf577a258c946a757a13a58a4460503b40961a1d02d1f882c39ec2cfd8ae0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0c8e1273d337b194b4411703f8567f770689a823dfae611f610ffa04bc251ed"
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