class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v1.2.36.tar.gz"
  sha256 "3c811a8a8086d6bd86be2f2dd770dcb27cc974b448698a23a54747262db8de89"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f430830cbe0055fd05d9a09286a32298985887d8968de68ab2edd19e18b41e83"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a91e8798b8735fb7685a98babf26ae17a8df58e9c945241e345d72ef862f385"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14b695c7cbbf6de5d2f437fc59c38e6c790a95653056335ba8f43ee1d0daaf5f"
    sha256 cellar: :any_skip_relocation, sonoma:        "30f5c44bc98428013fc426f3ef234054ce4a1e718ce044f9f10c79c8dca0b621"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b434487a291e7692439154871a03b94061bd45c549e911ee3fb6be5a0a6a95ba"
    sha256 cellar: :any,                 x86_64_linux:  "2c10b8b754b00042285ad1254697ee15480f3939f2e85ffde89c04371c69ebb1"
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