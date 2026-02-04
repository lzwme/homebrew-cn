class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v1.1.4.tar.gz"
  sha256 "b1b9b156b9db7b824177f8a454fa6e2326c960be225515dfafdc121dbfe448e6"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4e1fa527dbd61ae4d401bee3465b558f10a0ac4b90bbabc4648b48935247994b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dabbcf67a8fa8d7a4ae7d43c1e146e720399f1ab5623517722635306ad44102a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6a519d8f7e1286f1e6951a9b014a4b1ee44f64b09b37fa67f2db0d954e29747"
    sha256 cellar: :any_skip_relocation, sonoma:        "94e9eb7ddb0b1257b265d7abaaf70d55d019abc36c696d44e75208ed178b948d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "141ae3f4474213ddf363649c0613b13a92e28792aae58bae01b38ef9384ded70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "076fbb410cef07d925e8c355802d562ad876ea9c0dd948b61bbb1423ae46f7a4"
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