class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v1.2.45.tar.gz"
  sha256 "056252fcb413d845d6d318bcf4f8d968db6d04707bebf7ecb4bf8e7d36ce8b9c"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4ae1e678b567923e1aaedab8949e0545d13b53ce8f102a368d498bd53636dd8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f625da43e8742f0509bc50f322811cb13dd2cb495db5116efccda7c7f51dea1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "292d84ca336b8f76b1f54b6580285bc5b21071cfcd272624c3062694c5dbb325"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "73e7d344aa6bbe412a9e74a2a327dd0a972348636c8bca23ab84f700ef78f0ab"
    sha256 cellar: :any,                 x86_64_linux:  "fe6abb025204199ccf0082ca21680d0624692d149a65e86115322cd522f6b23d"
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