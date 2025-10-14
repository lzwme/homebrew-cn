class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v0.30.16.tar.gz"
  sha256 "42771c1f9b01b15c258d93ac49f1555095a4ce2cbb3a41bcaa2f073ed5a05ac8"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d2c80edae4765042bd874b64284b4509e7e40ff74e310e7d09b28b2f68562466"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "709fa6c904a82543157de147b1204dc7519427c47c7f3b55ab8aac8d6c1fb5fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d0b67e6af8fa43b91cfe8a830b3881b4d9e3c4483b98636c06a70d7ae9d1832"
    sha256 cellar: :any_skip_relocation, sonoma:        "70612f49b9ab541d2b07d56ffdd3f072f3a8cdef275cd40baf0be039eaea65cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc4954f643e5f370dde9112bbc7c68b90f1535de6db620767f6a44567adcd4eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f8d09b9b7580eae608019fbb2cfa4b1d7f628651f35e84b0e1d37e0a5cbad6b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.io/release-utils/version.gitVersion=#{version}
      -X sigs.k8s.io/release-utils/version.gitCommit=brew
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
          - alpine-base

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

    assert_match version.to_s, shell_output("#{bin}/apko version 2>&1")
  end
end