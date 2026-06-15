class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v1.2.17.tar.gz"
  sha256 "12af82ec319f989c82da2ff5ef59a19822fc0193158f6510b0ada3b72f2d7662"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc1947f4120344ac82181f82d75496bcc49d98999b028beab12c78eaaacb2a9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "114e9b3cd923ab14f7433568a07796e98f9e2a3d857d95db923d3dbbd82f2d4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9e493e9ecec99194334281d7214ab90afd74bbb8628cb3b61c80339153f065a"
    sha256 cellar: :any_skip_relocation, sonoma:        "15babf7d2d1fcc12f796eb058372a2a29d6d6ef577dca0c29d96d33a8979c2c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5d50a4b619aa70fc0f581ef5d6f2af16b6d13ad60eb84ca0a014222e8125bda"
    sha256 cellar: :any,                 x86_64_linux:  "25027e15edd2b52fd1ad7df11eb6107bf3b27c11dd97a95b7385c37f6563c229"
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