class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "50c414b3296017fa86f5ec57b9370a3d6f855b7c646f635c52c7a741e6779dc0"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "868bab34af86798e5e41c88c687a0e2d848250fdc3c369f5f4bde0441584ea11"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61241adda72e5b20588807fcc91898b05c64b42a8155bc2ae0418aa2da493f4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5f87b5999562804f4f5c2dc00d6d1be38ff18fd50911898f8a7da1053408ad5"
    sha256 cellar: :any_skip_relocation, sonoma:        "35f450053f148842534df5ed36919c9c0e187af82c736363e51241ec6e0a2d2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb9742b62d37010d0ef55dd7af7c43969314b03ced3d486a2a0d38d803e9f057"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "219606b0bb632f7d809737ac67d000dcc1729f44855d4dea330ea3ed708c6677"
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