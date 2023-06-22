class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https://kubefirst.io/"
  url "https://ghproxy.com/https://github.com/kubefirst/kubefirst/archive/refs/tags/v2.1.5.tar.gz"
  sha256 "3385723863c2e76fa7b6f3efe4178a3776f083cc96a09b2b9b4d047808a198cb"
  license "MIT"
  head "https://github.com/kubefirst/kubefirst.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "82be9823801e12de255329ce55a1e16c4ba901a4c415207b5286c05da255a749"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d176cac23ebb03c9fa11e55d3ae4439032af6e50af11eec3bb2e485fe39d6901"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2ee9bc21e4260e3d2796377a047a2a6a628d5d53ea3fb59d9546b8e41c09785e"
    sha256 cellar: :any_skip_relocation, ventura:        "c42dc3d9716f6b482bfa81af61ededcce1a4b2230a5e73029cb20f1b5608a33d"
    sha256 cellar: :any_skip_relocation, monterey:       "364b6698ff420f7e4cfb458e78ccc818b5b6ff213b3757640e0fe5c06905173c"
    sha256 cellar: :any_skip_relocation, big_sur:        "7020f0986383c144c64a52a861a202b6ce9a8edda632f131104c8ffb2f050ead"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2209ed6a55997dff1e8abd8ccf430e69147da06e44ca0936859fd83d1e8f76b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/kubefirst/runtime/configs.K1Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"kubefirst", "completion")
  end

  test do
    system bin/"kubefirst", "info"
    assert_match "k1-paths:", (testpath/".kubefirst").read
    assert_predicate testpath/".k1/logs", :exist?

    assert_match version.to_s, shell_output("#{bin}/kubefirst version")
  end
end