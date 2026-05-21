class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v2.21.0",
      revision: "56be91e57d2f7ea13c65cfbd14d5e31178cd0510"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "086c8be24a02cbe1eebee2ef2a6fa293de4a40a8fedf05b4b1d2cc760e5556df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5284e5b83613e03e7ff56bf463a5d0711cee91dc7a53b4ae22392fa2cda199ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "434fd9a4f12754227fbeb3d4c1664daea29f7e5e740851af178872dc9e9d125e"
    sha256 cellar: :any_skip_relocation, sonoma:        "41defc6a9e162c8108c8e2a96d5579d6ffe78a5075b028bc394babbbffbac189"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e837f265827a30cfaa69c31d377c81a4e0b1c3385cfc7eded7eea92cfa3dcf56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f8900e45c1e4b7e4e381b379ad4cae6f729ab62cb3dbf9a690e634e44ab2d49"
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