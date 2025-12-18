class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://ghfast.top/https://github.com/apollographql/rover/archive/refs/tags/v0.37.1.tar.gz"
  sha256 "6bdf352d9a92ce2fb2e89296afd8ed4dcc91840371deeab05da256e0324d0b7b"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ee9bfb422a573e2509146afa4aea201e12dbb1d976524d58a0d4d42d333956b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aac8d57e4efb3ef8b9d88163b93bdf01e5d3270aba2de3bf37ddf2bfe61605ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85da6a2b7b877157794c49e98809d2dde001e16e9a49dad7bcba2cb9e230ec99"
    sha256 cellar: :any_skip_relocation, sonoma:        "abd0cebeb7deb28679009706a8e580335dda6e9ec922ad304ca65b0f0fee5079"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16f0899da327664c614f1f2557a4d4f7e02f57baa06350773b52ae7230a12952"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0b7e41ad8edc910d257abfb16e7872ebd246c9799aed0c9029fe46aa6198a31"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"rover", "completion", shells: [:bash, :zsh])
  end

  test do
    output = shell_output("#{bin}/rover graph introspect https://graphqlzero.almansi.me/api")
    assert_match "directive @specifiedBy", output

    assert_match version.to_s, shell_output("#{bin}/rover --version")
  end
end