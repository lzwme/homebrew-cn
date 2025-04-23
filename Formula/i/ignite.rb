class Ignite < Formula
  desc "Build, launch, and maintain any crypto application with Ignite CLI"
  homepage "https:docs.ignite.com"
  url "https:github.comignitecliarchiverefstagsv28.9.0.tar.gz"
  sha256 "fe924ea64af54de9403e83918b95842bf84a4e74f366099ca51c6bfcf7ed1ffa"
  license "Apache-2.0"
  head "https:github.comignitecli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "991049057b121290f5e064167b2e2c6b23b8760e22265a63ef133ec205305215"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1caee2c6d3017b4693f46711a9f8f142baa1b19449fb3ea06ce39c11ea9f2373"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "24edb252f2d78a85e061eacd6640c3c0c118587ad8c2ddcb89b0d391b007ce05"
    sha256 cellar: :any_skip_relocation, sonoma:        "648c601eac8718221594027424aa558f24498ede95dba1a98411a4e6d54972e2"
    sha256 cellar: :any_skip_relocation, ventura:       "48b89611ff6dd0bd897c453c0afa7acccc7385afdab1ebf9fcb389b806caa4f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a848dd275ed061447d8a56e65b4481ebe6001d0a18fd9ae3cfff2123d6443915"
  end

  depends_on "go"
  depends_on "node"

  def install
    system "go", "build", "-mod=readonly", *std_go_args(ldflags: "-s -w", output: bin"ignite"), ".ignitecmdignite"
  end

  test do
    ENV["DO_NOT_TRACK"] = "1"
    system bin"ignite", "s", "chain", "mars"
    sleep 2
    assert_path_exists testpath"marsgo.mod"
  end
end