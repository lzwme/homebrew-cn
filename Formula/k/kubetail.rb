class Kubetail < Formula
  desc "Logging tool for Kubernetes with a real-time web dashboard"
  homepage "https:www.kubetail.com"
  url "https:github.comkubetail-orgkubetailarchiverefstagscliv0.1.5.tar.gz"
  sha256 "7a3bca800a606a5d8834086755e0130e8f5867a3c052008e0f5275040314fb98"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{^cliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4f7c4d2a924c0dbc1544e6d1d7d1a02c8913e41df83cecfa8983124926cfe04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "606d10a7d0ff3e3dd5089c31efe1a0368885a7a724cc9d80b3c6858592a09a83"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "67a40b3361a0b4c80c43079c4e41320caff616b0a8e67cf164039cd3b2f4e34b"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0e96d4efc98962b93b8f856763bf8161f8fe085bc4d5c82b65660fe793726db"
    sha256 cellar: :any_skip_relocation, ventura:       "4f5806a1e0306ff6ca4f8935f167d741fa0e1e41d23d9f2b942acb2c28becbb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad1aebd2a1a7d6e2bbff679caf39623f7d783a48b48c0fe4a2224ec63377338b"
  end

  depends_on "go" => :build
  depends_on "make" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "binkubetail"
    generate_completions_from_executable(bin"kubetail", "completion")
  end

  test do
    command_output = shell_output("#{bin}kubetail serve --test")
    assert_match "ok", command_output

    assert_match version.to_s, shell_output("#{bin}kubetail --version")
  end
end