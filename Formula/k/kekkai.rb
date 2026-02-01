class Kekkai < Formula
  desc "File integrity monitoring tool"
  homepage "https://github.com/catatsuy/kekkai"
  url "https://ghfast.top/https://github.com/catatsuy/kekkai/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "809e74f5f387f4e39f542fbd6dfcb5bf92696892be83df7ad42ace64093d7702"
  license "MIT"
  head "https://github.com/catatsuy/kekkai.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "483597e0f426744defd8b8c4ff215ac538fc56cfa2ba60b616fc583fc86ee08d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "483597e0f426744defd8b8c4ff215ac538fc56cfa2ba60b616fc583fc86ee08d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "483597e0f426744defd8b8c4ff215ac538fc56cfa2ba60b616fc583fc86ee08d"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d24d9915fed80946831b0fcfddfd1e06bfc02daf9ce5f67421aeb299ece8b0a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b902cfc2ab51665f5500ff10f9c34576440a6379a2229c8ba61e0c55ab6f1ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e21f3b298a9f5b24b0a1145bb762eb035966effda5e767f6cfee883e5ded60ce"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/catatsuy/kekkai/internal/cli.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/kekkai"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kekkai version")

    system bin/"kekkai", "generate", "--output", "kekkai-manifest.json"
    assert_match "files", (testpath/"kekkai-manifest.json").read
  end
end