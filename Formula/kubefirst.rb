class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https://kubefirst.io/"
  url "https://ghproxy.com/https://github.com/kubefirst/kubefirst/archive/refs/tags/v2.2.7.tar.gz"
  sha256 "3d9650513a8f318f6fe5a90269ff488270bdae38f156f5f98064e9089c79cd1e"
  license "MIT"
  head "https://github.com/kubefirst/kubefirst.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "66811c41e709b1786f50a1eb61f446905487360f666c9994aeccdf2dd249fe2e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e97d2403011bf18d426182b979598b21d1cd425ebbbd38cfd570eded80174eb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e8ebdb53c026b6bddd1d8e3b72326974c297ac8126179938822fe20e4e98ad1"
    sha256 cellar: :any_skip_relocation, ventura:        "ae13f116eb96eafdf6ab2c75d2696ec30e662ee331d28ec6787f97ec49fb1e5f"
    sha256 cellar: :any_skip_relocation, monterey:       "6ff3489a4f77558c2ba04f42e48c09273e9437efb76d090450b833f246c733e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "f21befe55c3f0446f1d438a4805101ca21243d22fac7477624340083e26218d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d5b4099f045fea825abc85a86528216df549cfcc3f21e7f463c6b5cb808ed2d"
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