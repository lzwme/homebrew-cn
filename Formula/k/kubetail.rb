class Kubetail < Formula
  desc "Logging tool for Kubernetes with a real-time web dashboard"
  homepage "https:www.kubetail.com"
  url "https:github.comkubetail-orgkubetailarchiverefstagscliv0.4.2.tar.gz"
  sha256 "515e42c83ad1df9c79ffce97fbc8ddacc6592945b932b438a4c2b2858e371b48"
  license "Apache-2.0"
  head "https:github.comkubetail-orgkubetail.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70d02efe84a4bf488a96ba974d123a50b1c08e7740702340bf8cecf333bab22e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bcd8ada6f847897887df2f08b6ee18ec4254699ef65975d96fe7f96b5b282956"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d0f8cdc35402faf2d000dfd6d6c24c7e2573334e8ab557efeb3fd2211ed5c7d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "e62194680eb2c81689fe5a97edcad9ebe2334fee6d9796a1c6258abad480ab6a"
    sha256 cellar: :any_skip_relocation, ventura:       "b5878a9eee9ecdf9102830825e24e59196bbde00e6f7cf9d02810d790b385922"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57970640a7d6699bc53b9be103063ba0dd39f5b644163363a5ad45fecb638ebe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5cc0be66e98c33b4d88affebf1e5d4a37f20a090fec1e0525b56d4fad0b910cd"
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