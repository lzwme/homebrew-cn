class Nom < Formula
  desc "RSS reader for the terminal"
  homepage "https://github.com/guyfedwards/nom"
  url "https://ghfast.top/https://github.com/guyfedwards/nom/archive/refs/tags/v3.2.5.tar.gz"
  sha256 "f12c6f8429808a64db46cc3530454d9bd131e3bd4027c57720ab096853cca2e0"
  license "GPL-3.0-only"
  head "https://github.com/guyfedwards/nom.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9441b757550dadf45e97e6be12608e0caee7c9f2ba32456329369d88e9491dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1e889b6f1e4cb858550245e9695a50fabbebc55e93a469d3da428eebc194705"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ef3cadf6462d7720dffbae0a9ed195ae661009d0b1435999f7a067d2a82d648"
    sha256 cellar: :any_skip_relocation, sonoma:        "b19fdd05a834b74dee81f0103ba6fce376fc2e88d20f28527d36fb1a8e24f4f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb77836c2ed82709e2d52a1055443fe314e0aaaa3fa3a5937181c910c319709c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0265f8176c39d0be22c4309143da9b93a7695674a50c194fe49fb09087255a5c"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" # Required by `go-sqlite3`

    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/nom"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nom version")

    assert_match "configpath", shell_output("#{bin}/nom config")
  end
end