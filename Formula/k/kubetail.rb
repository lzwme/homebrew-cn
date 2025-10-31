class Kubetail < Formula
  desc "Logging tool for Kubernetes with a real-time web dashboard"
  homepage "https://www.kubetail.com/"
  url "https://ghfast.top/https://github.com/kubetail-org/kubetail/archive/refs/tags/cli/v0.10.0.tar.gz"
  sha256 "ea246a2088cfd12b00f41f82a7616e96087003ead05a13f7ec57e64fa985e30d"
  license "Apache-2.0"
  head "https://github.com/kubetail-org/kubetail.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1221d17d2f6f686d501da3a5c53b717524ff4f596472cec36b827573ae15a25f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c965a36dc60a41c589d8cee4eced98d4070ef1306a75799ebddbdd0469ff7a2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d33ac9a75d73fa24f16086dc27088c7a1d1db8cf393e18dc6e965d2091d5318"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8701f0d8fcb456d908546c97486495b330ff4d9cd0c95c8c96c6efbd0ec56cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "133439091e681eac931d047f5583118dd100cadf02e6749291fbffb55b6282e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c18b2c6e539ec1d787ed5d14e586a9f5b83ecdee2d2dcc7f7ae234992940945c"
  end

  depends_on "go" => :build
  depends_on "make" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "bin/kubetail"
    generate_completions_from_executable(bin/"kubetail", "completion")
  end

  test do
    command_output = shell_output("#{bin}/kubetail serve --test")
    assert_match "ok", command_output

    assert_match version.to_s, shell_output("#{bin}/kubetail --version")
  end
end