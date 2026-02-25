class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v1.1.11.tar.gz"
  sha256 "40b0161f2a93855c485c82db17fd12946584d8708dd6fc87e9ba760ded9f2edc"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b27d84bfb93f813d241615aa8e70577434d6288e83108d079b2ad71d79a74cd9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66dc5ef696c44080436f097ad5160c2f311e1ad1d456589d258bbd1b63fff23e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "399cd0a05d0be17901e0e144792a53b79c24519894983e552193620ca4c5297c"
    sha256 cellar: :any_skip_relocation, sonoma:        "0fafac56b5b2cbb39fefb194c73e3fea5eb02078a8ea1fdcf3c7283b3670679d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e07836fe53859c730032b657716fec44c0dbf6cca412ce62d0251e3bdf96023"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d00d7ea42ff7fff214284b32f2907d560260f983938ee3e5c204174464286537"
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