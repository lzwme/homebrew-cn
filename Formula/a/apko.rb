class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v0.30.30.tar.gz"
  sha256 "dbb33326f823cd3ef7c9cc10e91cbc8eccec15365f34d8f94bee12590b132d5d"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e57301106fcf0c777b172c81fe9ae13a55cb711cb32e74e6870709bfb764c863"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf327399a82e82e64ef1c075da53bc57a29ed508db505fc9ae59483ed1272689"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb163ef552b23cbae36cf018f0e754d15689b55291956e5577f49e20f8bf80c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f909e98eb4ece05249c6970cbb817fabc13545964f5af0636221826d3f97fee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7efca195ed720f804f76dddc55dd5676197ff13c0d2e86981dcf342c46b40726"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "503e751d4890eadf7174b9b78eadc7293b8d7ca33e6eaf60501b5fc552157e76"
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

    generate_completions_from_executable(bin/"apko", "completion")
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