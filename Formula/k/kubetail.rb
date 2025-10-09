class Kubetail < Formula
  desc "Logging tool for Kubernetes with a real-time web dashboard"
  homepage "https://www.kubetail.com/"
  url "https://ghfast.top/https://github.com/kubetail-org/kubetail/archive/refs/tags/cli/v0.9.0.tar.gz"
  sha256 "f71cf335f81e76f882efe11feed4ed8af691cc1d9fa8f6b5ee630ee22a99dabb"
  license "Apache-2.0"
  head "https://github.com/kubetail-org/kubetail.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c9ae4b1eb0ca3642394f77379c29210686e0b8b2c95c3a09582b319ac5705575"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6fa6ca8c832d72127a7649ed7426d60ec59998ef2a12bfb32afc1da116f97276"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "574afe4664ca707466cf641d2091e7b020face2e1466703e74a33d971185313a"
    sha256 cellar: :any_skip_relocation, sonoma:        "11e3928d3875f4409b2d592f88453854769073787b2cbdd729088464f2fb2679"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7cfc305b00548cf472ddac08eee846e19f84d30829762c28db4595980d628dd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5636c98cd01917c2e8c6153b9c25ab0e98b80903078627cbf9defc5c4f3f78c"
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