class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https://kubefirst.io/"
  url "https://ghproxy.com/https://github.com/kubefirst/kubefirst/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "f2be5c0f81c8638e4e48f0f873509b8f1919f6ba640689a17ee5cc3c736c56a0"
  license "MIT"
  head "https://github.com/kubefirst/kubefirst.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a26925cfada7127166824f2ee40d78c4210ab489b50d4ed8cdbd3a150580214c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ed5d24923616ed70b35af9147f05cd7ef9a5bb4739dae188980a79b70fac0ca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4227190d9fad22ffbe3b8c06b703e4b6bed9eadb4b030f365b6d81af29f75031"
    sha256 cellar: :any_skip_relocation, ventura:        "7a6f212f205f0494b269e4410892284db66b4a15ceeb3d30ea73b6dae380789c"
    sha256 cellar: :any_skip_relocation, monterey:       "da6d799cf70009110d50ff5ace922d8865011416f1d055f5e027ea1cf0b071e0"
    sha256 cellar: :any_skip_relocation, big_sur:        "a96623b0f919bed2a2fa887cd5b04bb626c0d93664cedde9f302ad2dc3302352"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee7ea9e2a9fe3cf466a82af290f64adf74d8b1651d0c5e9ecd5d99455ac2e045"
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