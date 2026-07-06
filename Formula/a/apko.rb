class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v1.2.22.tar.gz"
  sha256 "09fecc5cce13e32f34896290cf3d703aab34d76a66653363d31aaf2508b11af9"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88c3109a778c3cb6f7373794cb139c1e8ebe41dc59527d55798cadbd2d89ae15"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90fa11b84efeb8604342184ea1604d8bb84e2f70fbd381f289f5a8f0aad31df4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "180825ff9e294c3cb4ad2e85742b4d94d7680bdb8427ee07d954d53097e8f3c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e09006fd7a7d3862a5580bc5398e0e1cd5cbe76a16b808a225d12d6c4ba317c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3cf0ff2a6382e1f2126efeecc8ae5acdbbc2b23f19e0fdf5e88eb404c7f2251e"
    sha256 cellar: :any,                 x86_64_linux:  "18e86f8def6b25865a64a6c346881b68711e7ea46c0d8654b2ae1469649a72c4"
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