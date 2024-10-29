class Kubetail < Formula
  desc "Logging tool for Kubernetes with a real-time web dashboard"
  homepage "https:www.kubetail.com"
  url "https:github.comkubetail-orgkubetailarchiverefstagscliv0.0.7.tar.gz"
  sha256 "7b5a19702f514ecf2789b949105d93837ec876f2e78927b9d518cfe6f1859ec1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{^cliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40c6e03ee085553aec3e2acd213073d07d0e1e4a8645dcf2d86c61635e689e33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79d957a05db593a5e55b4d36d6d9e97573417f54bfca07f95c2b491d5901fded"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "44ed7695865a2fed8999edeb2cd6a7fc8a6969788adeae61f58d1bfad0f1f7f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "87e66066ea85355dc4b88ec8d56ceea3b943472be570a902e2f7a6b2ebc1031d"
    sha256 cellar: :any_skip_relocation, ventura:       "6376840ff6416fdeb7fd365036fddf6451888c371cc25a787e02c39dd68b3eee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d77b6f6f664f773db9cf6b8ac11ebeae3c442f00b0184f960bae41ca07dd7c53"
  end

  depends_on "go" => :build
  depends_on "make" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "make", "build"
    bin.install "binkubetail"
    generate_completions_from_executable(bin"kubetail", "completion")
  end

  test do
    command_output = shell_output("#{bin}kubetail serve --test")
    assert_match "ok", command_output
  end
end