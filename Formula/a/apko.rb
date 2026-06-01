class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v1.2.15.tar.gz"
  sha256 "c6dd8405c326a4712fe358af4dacacaa3c9cec88ed45ff55d1189f2c0ae870c1"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ec3b62244a6ee300c3ec8377781fab831254b70e0602d0f20c1da725ff32d9a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e5e4d0dd89227770fd7282f86cd5cf6f1bcf4918ece9a1c1fbb20d5b4afab64"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "346e5880c10258d593abe1bbe897ee4bae7db282a77bb3dd488d541283f14f80"
    sha256 cellar: :any_skip_relocation, sonoma:        "5668787751cfc6bf99df19c144fda82d1b97873165e3f7509c0413d68dc72c16"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3ba95cbf696eaaa111fa0b522275e3771a4a4ca632fe3cbbc225b31e745d1f6"
    sha256 cellar: :any,                 x86_64_linux:  "63ac3215118bb5cbc3915b388682b939bc1c27be62266ef880c2ab86c9aa6045"
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