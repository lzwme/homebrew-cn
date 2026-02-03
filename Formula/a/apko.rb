class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "d142be338a2fb8ffe66ee41df6be8f329602579a8540700231102d73bece83d0"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/apko.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce78ba849248fa796281790587546b4f504248d83c247e25cf01af1f3ef7df61"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8ae597239ba1ac665efd64286557e66c7b6e80aa80a644b344b9a0d0dd8bbfa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da0f8bb0c9e89f5c80b1cf359b14723dc6095e09f7dd77e20e2e8409090e6300"
    sha256 cellar: :any_skip_relocation, sonoma:        "13dd68784519157233a2bb3a8bc71bdece46a7b72dc935f6c607ef5ac70f5a90"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6197bdd5314901365f6a293f68b927d91503ffb653c9ad70656ae71d32f3d84c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed4ffaab6735d37a8a8dd692c56ebe35f8242b7b2067a6fe7648fa6c947a5a8c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.io/release-utils/version.gitVersion=#{version}
      -X sigs.k8s.io/release-utils/version.gitCommit=#{tap.user}
      -X sigs.k8s.io/release-utils/version.gitTreeState=clean
      -X sigs.k8s.io/release-utils/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"apko", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"test.yml").write <<~YAML
      contents:
        repositories:
          - https://dl-cdn.alpinelinux.org/alpine/edge/main
        packages:
          - apk-tools

      entrypoint:
        command: /bin/sh -l

      # optional environment configuration
      environment:
        PATH: /usr/sbin:/sbin:/usr/bin:/bin

      # only key found for arch riscv64 [edge],
      archs:
        - riscv64
    YAML
    system bin/"apko", "build", testpath/"test.yml", "apko-alpine:test", "apko-alpine.tar"
    assert_path_exists testpath/"apko-alpine.tar"

    assert_match version.to_s, shell_output("#{bin}/apko version")
  end
end