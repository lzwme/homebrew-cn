class Kubetail < Formula
  desc "Logging tool for Kubernetes with a real-time web dashboard"
  homepage "https:www.kubetail.com"
  url "https:github.comkubetail-orgkubetailarchiverefstagscliv0.5.2.tar.gz"
  sha256 "f36ac19fb74e4af6420ed72c37d502c68cf671556dac24a91cb1597c94a80812"
  license "Apache-2.0"
  head "https:github.comkubetail-orgkubetail.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2490fe856a4252f468f27f8ac3d32fe7bb516c54be9245111d9608154a27fae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5167a0a9556507c375dba31b910d4cd795462e001c349302d913e7ae33fa0651"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b4d3799b17f3d45b6a8c8ab73c23973ccd8d8129bf0d664074fd17bb002cc5a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "264d170fa4bf75842f8520eefc1fe998a59fcc131ec9e4006c0b2f6dc0a3d5ee"
    sha256 cellar: :any_skip_relocation, ventura:       "2ba02f03b5a154ee821e8bb9f726666463ae46d28ec3332d2bf9eb2240cb1058"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "066547ad5f42888e3cdd37962f5af0b33c97c2627d4fc14b8aa8050966e6d463"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63c08373568ad38527a4a7dcdff763a1dd843b2127e41beddeb9a6814c947094"
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