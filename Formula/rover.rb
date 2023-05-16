class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://ghproxy.com/https://github.com/apollographql/rover/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "f0c89158992d780f28b2955604e079ea23b6d6379a3cdbb6e43d93119fb90ee2"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9788d987e12bc333e474a95138c93aa2ed280de30d0052c7ed461db9bf3cee3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dde0b2f197183094b15c2bf7c0d562d4edcd5c0fbf70981f9018e6cdfd4bb2a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "95bfd988857f9033d76cd1552f87b1ea786dab70bb7c1199bf132763650edf02"
    sha256 cellar: :any_skip_relocation, ventura:        "5e0572ea4a685384a385bf9b10e9d35e04f36c16426c8ab180bf6be60672d69a"
    sha256 cellar: :any_skip_relocation, monterey:       "c8790521a45381da9e40538d8948691fa98b3eb8ab3893473f44c750cd12d258"
    sha256 cellar: :any_skip_relocation, big_sur:        "ec8d26618dfdc9407e6ecbd5cf2471eca8ae7a264d119a3f6ab268c87b3f324d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6405f0a5bc20a277137afa66e23dcdbb99793fdd757d7e7d4fdcccae744068e3"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/rover graph introspect https://graphqlzero.almansi.me/api")
    assert_match "directive @cacheControl", output

    assert_match version.to_s, shell_output("#{bin}/rover --version")
  end
end