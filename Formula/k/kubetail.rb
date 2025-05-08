class Kubetail < Formula
  desc "Logging tool for Kubernetes with a real-time web dashboard"
  homepage "https:www.kubetail.com"
  url "https:github.comkubetail-orgkubetailarchiverefstagscliv0.5.1.tar.gz"
  sha256 "01cb656a34d22fc60284da29b11fd5ae5496e3f0933d5d51b68d0a8ab5cf7b75"
  license "Apache-2.0"
  head "https:github.comkubetail-orgkubetail.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08d770b4d12bd517933aca0f6b2bd726f0c691ede02c39d47e1c8417cdd8f684"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5c3095d69430a00d0877718b93b625cd99f9ae787d557492a70b9be22c2f3cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "54f5d4415eb6539f14e4ffddc9a7cd59279940967777a228942555d85b863b53"
    sha256 cellar: :any_skip_relocation, sonoma:        "f61968b3fd9acc2936f34a2cfa85fba3446cffd0cb8ef89a0ef47cd0294e6b7d"
    sha256 cellar: :any_skip_relocation, ventura:       "9dc6117fba929c990705e30769265392bf0dae429178a24143e208119599ed29"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b05ca7aa7db0ac311354a9613bd0e525f3fd15af8f785a7219c722b1f1b2c4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a7dddd44511afaa60c30ade85e78a833237afecb20bc4eccb76dce97b44817e"
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