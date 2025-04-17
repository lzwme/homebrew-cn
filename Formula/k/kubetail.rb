class Kubetail < Formula
  desc "Logging tool for Kubernetes with a real-time web dashboard"
  homepage "https:www.kubetail.com"
  url "https:github.comkubetail-orgkubetailarchiverefstagscliv0.3.0.tar.gz"
  sha256 "df1d5341a1efdf36db7559684446cc18814da65527f2f3c7e72b2bbdbfd4c161"
  license "Apache-2.0"
  head "https:github.comkubetail-orgkubetail.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a669ab4391ed1c8a562a5f0f34953719ad9f91be3f2299a2c6e583a2a93bb3aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e0ff9480d1ee520c23a8f424af91cdf9bef931e11755f26c1035f7f893bb037"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3b5de9ab025dd02da881206d175c5071273a16e4fc7a4d94bd7414abd5878a66"
    sha256 cellar: :any_skip_relocation, sonoma:        "1bfbfcfe16c298c93abbe8d232f365b04f4bb4d92df0a8e521c93dc5edd966ca"
    sha256 cellar: :any_skip_relocation, ventura:       "7a33256ee1523c37ba062b5c9dc94add0141b7a7a49cfe58d84d95a71407945b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9fadccfadb6f8e0c84dbe40d13b0ffd4d3243d62c387ea0bab8f42f702e6ca14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b48b764b46fd7e329dc89fb53da083896c434c78e1d83f2588993a23d57e46d2"
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