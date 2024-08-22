class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https:www.apollographql.comdocsrover"
  url "https:github.comapollographqlroverarchiverefstagsv0.26.0.tar.gz"
  sha256 "5611df30dfc68c99047e776f4be98471cf88ebd898aa713301f3f168af6b9244"
  license "MIT"
  head "https:github.comapollographqlrover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ac45bb980072f23f8f2cc26a586cb94825c4a8016d0d168565db4e82fac9eec2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d11febcac8b503ccd26ea37ab5d6e004ba376e9f38016ab37f4e46f9c7a8f3ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "602a407cca04f6535eb2386c0524a5239bcddbc7ec8bb852e7562ad5a590fd79"
    sha256 cellar: :any_skip_relocation, sonoma:         "71ed34a4958aec61ad3b735e226c7403ae204aeb2f016be272a985eb89a4df09"
    sha256 cellar: :any_skip_relocation, ventura:        "4d40b01e902a72d2e84fe743767a2e6a0ab7892b91e9b8896b85cedc765b7505"
    sha256 cellar: :any_skip_relocation, monterey:       "6a7675c96f12140d5d5793e3cb6aeafb1131f8839e7f4ca459bf0643d3dd0dd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "017ab2d206a45bf2d7c33f014c63f31ceb1c8604c05c1a51518bfba7a4d0bbec"
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