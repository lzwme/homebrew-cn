class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https://kubefirst.io/"
  url "https://ghproxy.com/https://github.com/kubefirst/kubefirst/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "80b4276b88c270693a94660a3b33f8a771436093642d0c8efe0c687ca3ecc4b0"
  license "MIT"
  head "https://github.com/kubefirst/kubefirst.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0c4aca4cf4e24efee6d27946fc738ba48b0e54fb6a662eeb0516bf6db0c47c3e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a20793795313fc4518934a87159943a4f60ec493f75cc10bf849f50ebc2e346"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4d6a84d8633fce6975b659741b955123c5cb305e24661c80ba72458b11826e58"
    sha256 cellar: :any_skip_relocation, ventura:        "8a83f749059aab0acc33773b435836b6ed0d842f96b2d7c0a020269129d1a468"
    sha256 cellar: :any_skip_relocation, monterey:       "c64cacab0b82c92a4a1fa43b46d1cfbbd8d4294b6076ea549b3c1386ac0a5b69"
    sha256 cellar: :any_skip_relocation, big_sur:        "3bcb48906847ea222f3f7a8b67355084d11c2d38ae6b1e0f43a5446ed180e4eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7954b89efea75b5965076f155de951d091348bf60f31cc52e2e70bb98ac4dc7d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/kubefirst/runtime/configs.K1Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"kubefirst", "completion")
  end

  test do
    system bin/"kubefirst", "info"
    assert_match "k1-paths:", (testpath/".kubefirst").read
    assert_predicate testpath/".k1/logs", :exist?

    assert_match "v#{version}", shell_output("#{bin}/kubefirst version")
  end
end