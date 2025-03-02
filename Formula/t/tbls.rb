class Tbls < Formula
  desc "CI-Friendly tool for document a database"
  homepage "https:github.comk1LoWtbls"
  url "https:github.comk1LoWtblsarchiverefstagsv1.82.0.tar.gz"
  sha256 "5fbcaa644e1c28f25ee3e616b9883e64bcc22bbcec83a999767afc12f1ca0ee7"
  license "MIT"
  head "https:github.comk1LoWtbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eec037d9d6f78329427a10d69cfb143d7876deb6f271d0db3809f91478f74b70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "077381887b39564c14f3c0f167fb5d518f892eca0b27f23752331935717294ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a67dc2e08a13fdfb4f824a8fb3e1f89c60d5780661bd3a7c86ee5cc9e79a63f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "58af7223fad769a53908a7364fe7282faecc1ac76735ff08c507ff98ae2b6cf3"
    sha256 cellar: :any_skip_relocation, ventura:       "d759752dc7afa4f12723c6c519c9cf55c3264d81d4451b33183303cd58f109d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "275360abce66cabf0aad7deb0297951fde9aa2ba0dad633fad875ba150d96194"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comk1LoWtbls.version=#{version}
      -X github.comk1LoWtbls.date=#{time.iso8601}
      -X github.comk1LoWtblsversion.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"tbls", "completion")
  end

  test do
    assert_match "unsupported driver", shell_output(bin"tbls doc", 1)
    assert_match version.to_s, shell_output(bin"tbls version")
  end
end