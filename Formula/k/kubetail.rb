class Kubetail < Formula
  desc "Logging tool for Kubernetes with a real-time web dashboard"
  homepage "https:www.kubetail.com"
  url "https:github.comkubetail-orgkubetailarchiverefstagscliv0.6.0.tar.gz"
  sha256 "1d79ce110dc70223741a118d736fcc3cbc7f31421b046d15690d13fd81b86352"
  license "Apache-2.0"
  head "https:github.comkubetail-orgkubetail.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9d331230e3fe186aa16b4df0edd91aac3a0be5cd36ed4f3683f5f6744095bae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba0d85ec58c393359f3260524994dc647f135477bd6a1248d89f8f37c83eae7a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8311ae003cd5a694e1d34c62b32c55cf3e2b41333ce5cc55e40ccfdfef4562e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a0736ab226c9a43347feaeb55ef40489ad5fd459f4fb98aca3797839f06b160"
    sha256 cellar: :any_skip_relocation, ventura:       "75932e0cf489dc15b031a63595007e518eb13f2a2e8de3d2eedae8759f54eb98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b083821fad7bc4a30e1805f971fdfe97747a3e0c89d19afc7e892a74161485a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a18f59f7009b3ebabc8234cdbed9b33fc1023ae3aa0c657eed253aab004b6dc9"
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