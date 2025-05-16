class Kubetail < Formula
  desc "Logging tool for Kubernetes with a real-time web dashboard"
  homepage "https:www.kubetail.com"
  url "https:github.comkubetail-orgkubetailarchiverefstagscliv0.5.3.tar.gz"
  sha256 "e4035d0f11851d772c579a4cb5d42456ef3b6c96a7eb1bf772fcfa923b724153"
  license "Apache-2.0"
  head "https:github.comkubetail-orgkubetail.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5bc3b788305f61351514c2c8438f7cffd024ed41f46d593b7b7db518350c1ee3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a4cbaad2f2a32b0c955eacfd9b75aa55977139acfe0810cce7fd94dcd940144"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a2ce969b576ac163b71dc49ca7b1ae80c1c156e0795e10be76e4f41146c9fab7"
    sha256 cellar: :any_skip_relocation, sonoma:        "8061b2d530fc683dc6d787593bfd216bba3a1821a0564d893c93029ce7a372f5"
    sha256 cellar: :any_skip_relocation, ventura:       "c8c8d86d99c1fde5e45c08076562a6c3190bab0b344c544338b854efe0790ca4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e5c659e814364a4f89234f030523fb35c3fcd93d5ae18d3cb84ea393b054333"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4f5b1aa8b28ef8dd93b185288c898b8a03f907fd3c68710585d402afe3f057b"
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