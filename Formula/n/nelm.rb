class Nelm < Formula
  desc "Kubernetes deployment tool that manages and deploys Helm Charts"
  homepage "https://github.com/werf/nelm"
  url "https://ghfast.top/https://github.com/werf/nelm/archive/refs/tags/v1.14.1.tar.gz"
  sha256 "a084734d4d7624f6334b0681a5ba676a328f2d2270268ddb4eab80ed5e2977aa"
  license "Apache-2.0"
  head "https://github.com/werf/nelm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "06f45382c6afa6b8bb2ca67e897cc71f46d1a79caf7cc4897d9fc9a13462cc00"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "997b7c992fa261cb6bc3e8c8d2feffd0ed8ef9ca5f4792b91094462e8ae202ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2216ad1021aa908ce3322740e263eeda971e1b57bb8d02fa8fbf6dc33c6591a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c5ee59c214780137cdc8e5fb0e9122385a3287ffe18625c8230a64c82b084c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03e3ed4236097a91bae83135dba4a20b34301633038e05df06c7612304011452"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2f66bc5b71e2f86acb822e3e299607c0e435dd0480e468d04de6fb822275234"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/werf/nelm/internal/common.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/nelm"

    generate_completions_from_executable(bin/"nelm", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nelm version")

    (testpath/"Chart.yaml").write <<~YAML
      apiVersion: v2
      name: mychart
      version: 1.0.0
      dependencies:
      - name: cert-manager
        version: 1.13.3
        repository: https://127.0.0.1
    YAML
    assert_match "Error: no cached repository", shell_output("#{bin}/nelm chart dependency download 2>&1", 1)
  end
end