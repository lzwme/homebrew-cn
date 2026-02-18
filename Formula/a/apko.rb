class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v1.1.8.tar.gz"
  sha256 "008c96a35412fad689498ffd089e22a6c3f3bce2ea2995b30bb16ed73c8f790f"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce89c27f6ab094cbfb8f26826fcccc86fa4a2a0382f36ce7acae6a26c48d17d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15485425bf49a48420c39eca31fdf907f18d79d28a301190a3a79fd1dc067ab3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5f3cb38b365be85fb084d2c4fc463c9f1be2fe16f59dca642668775c3677436"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9cffcb317c2d7244e6d24cc572c56ae9549f3f0139517751a9c9dd3a07b5a7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e3c057371f5f85854995c5e97bcce13a90237ac02bef8e28b6b7961c3137b96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b485e3175878578aae0b8d577964e0e53c66ccc193f2d93c5292808076c6423"
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