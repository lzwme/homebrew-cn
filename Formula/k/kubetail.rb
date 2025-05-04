class Kubetail < Formula
  desc "Logging tool for Kubernetes with a real-time web dashboard"
  homepage "https:www.kubetail.com"
  url "https:github.comkubetail-orgkubetailarchiverefstagscliv0.4.5.tar.gz"
  sha256 "108508a208d3b5eba03ab245f94fd2fab2cdcd53f957938d4bbec99389fb10ff"
  license "Apache-2.0"
  head "https:github.comkubetail-orgkubetail.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27573981a1a242edeab03618b6d8f45634b87b9d0993fc2588b1b16c5a267692"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba14ff3d02b8fd59216c58cff0c3ca983f65d7f6352697eccef919a066c221f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fb83e99004a361eaf473b8fea6b1ef41e58686db22a48068b8c606d84db7e779"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f0cbbf1ddbc1dce7219701f97a5180b539a46aa2d39fda65877b597ebb4aed8"
    sha256 cellar: :any_skip_relocation, ventura:       "7cd3d263c082d48a0764c33ff0fc9366344530c5b8ed6aedb06d3c7b1e6dd12e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54728dd9bd08a2d2042fc95c11667650f4cf29b21097515ef97f7ee679f9fb9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "977ba5954ae11087e77dfbda4d49fc669cca41eee9e85125aae0184cc36b7521"
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