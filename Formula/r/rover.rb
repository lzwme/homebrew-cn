class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https:www.apollographql.comdocsrover"
  url "https:github.comapollographqlroverarchiverefstagsv0.31.3.tar.gz"
  sha256 "8f73a51757b5789901efd8a00d26b9bb4aae3be1d7b853802e9478e31da1d122"
  license "MIT"
  head "https:github.comapollographqlrover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ba8bd4b7683ccfbf55084d5c3eaf54a4611d3e8415cf56461245b4ce923180e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20c50022e8c974404dd647213593e2c5911f81737b93a4fac1e05bc8c985fc4c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "81166c127e2668ddd1aa631a51bdafee11c088cbb552885a2fc62b13b4916870"
    sha256 cellar: :any_skip_relocation, sonoma:        "973cddca3c69a068e479e143225bb8129ad222a51a21103621cf4b9511b2a4c9"
    sha256 cellar: :any_skip_relocation, ventura:       "e0b99e4e8aabd6a6487c76c3cdbed6faddc57f35a5166a02a35203d37153f428"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a74a13f4f06ca62fb7a972ae139b8678a7ed029501553c48c10c0ab7aec11acd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8121203142f627154ba7efe96d76866dec2b944ab3d11c9cf6b2eaf73938ddb4"
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