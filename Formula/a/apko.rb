class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v1.2.41.tar.gz"
  sha256 "0c4fadb850f73f97b16af67df4709bfab059564097338842247b12e2921df1a1"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e38dd65f305fd5fffc600c4fb503f5c3ef02335d02c5855c9eeba0e2f836ab2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2dbbe49bbeb229d5cd9ebb391979a3c61d597af5364b72a88884b81f564ee151"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b00bf91ec806d63e948de07771049435f0d35e71483bc31dce4c327d0fbdc65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a87ac22b299f7d41a7b80a0d263b30e723be56b127a4ad3885d61c9e93bf367d"
    sha256 cellar: :any,                 x86_64_linux:  "f71891de76ec49ef9a7d3622aab34e24b6e66a744a430dbcbed3ff5f9f1456f3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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