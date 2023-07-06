class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v2.6.1",
      revision: "ae5cd52bc27103f11232bf2dd6635681d1dad2c2"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c35c756439ab6246aa60e74820a47f9ec18118c338827ff6738462588d2b472d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2fc67e85a4f4eb9b116e3d77427d42cee1611e310a12e5a6cb5fb352f022e1e6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "660e637a2e262c405a81e0f6197de6b0c5e8e45d2b6d23a1e0c10ad573eaf6cb"
    sha256 cellar: :any_skip_relocation, ventura:        "5e5d39a3cb343ab30b23a4054be790c76c6e15174862136316fc5ecc43b3825c"
    sha256 cellar: :any_skip_relocation, monterey:       "2ff28950788f63cb02852231d58f5aab6baaba9b148e85d13f4ae2c277266496"
    sha256 cellar: :any_skip_relocation, big_sur:        "3dae3b7307489328eb88a14e66b0c08e909f39cca17364b9dc0d4d3474e203ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98e6ab1732f7e21f49a65a3bc604be4cf72df7bfe864eefae2ee751a015c96f8"
  end

  depends_on "go" => :build

  def install
    system "make"
    bin.install "out/skaffold"
    generate_completions_from_executable(bin/"skaffold", "completion")
  end

  test do
    (testpath/"Dockerfile").write "FROM scratch"
    output = shell_output("#{bin}/skaffold init --analyze").chomp
    assert_equal '{"builders":[{"name":"Docker","payload":{"path":"Dockerfile"}}]}', output
  end
end