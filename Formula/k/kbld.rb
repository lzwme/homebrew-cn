class Kbld < Formula
  desc "Tool for building and pushing container images in development workflows"
  homepage "https://carvel.dev/kbld/"
  url "https://ghfast.top/https://github.com/carvel-dev/kbld/archive/refs/tags/v0.49.0.tar.gz"
  sha256 "5126535768a5e2f614f2d87fac0e9a0b1d8874ceaf09b3ddf074a270390028de"
  license "Apache-2.0"
  head "https://github.com/carvel-dev/kbld.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8fda09eab0b6d85f4f5dd133ab968ede3fb2df02384b8ed9f73751263d6f8286"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fda09eab0b6d85f4f5dd133ab968ede3fb2df02384b8ed9f73751263d6f8286"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fda09eab0b6d85f4f5dd133ab968ede3fb2df02384b8ed9f73751263d6f8286"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a15ac5118e2720e0e1af817d01c25f042ba75b4432dd0cab30734dce5ed1ebf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53a1929f6745be07ecd286fad405d9e8526027839a689ac727c9a7e5f0c0c1cc"
    sha256 cellar: :any,                 x86_64_linux:  "aeb5cd0b040db56f5b0d62317a4d2372accdbef0ab668b84ca6e8034a0fadadd"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X carvel.dev/kbld/pkg/kbld/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/kbld"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kbld --version")

    test_yaml = testpath/"test.yml"
    test_yaml.write <<~YAML
      ---
      apiVersion: v1
      kind: Pod
      metadata:
        name: test
      spec:
        containers:
        - name: test
          image: nginx:1.14.2
    YAML

    output = shell_output("#{bin}/kbld -f #{test_yaml}")
    assert_match "image: index.docker.io/library/nginx@sha256", output
  end
end