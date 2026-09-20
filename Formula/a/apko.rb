class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v1.4.3.tar.gz"
  sha256 "176a74689249d025a49ac2a6749ad6c5b33425bd46321139a3f82c270b946408"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "233e0a7a5b196ddbfa58c5041f9debc57d6c0249559475e212be4219c09a21ca"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "574543502aca41178ff023780d4b1309762412f348483c773df0c4da10451ac8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fc8c357ebbc4a6c882152cb384e77c77078a07954ba5f6239fc24e42123a9f7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "973b3701a5a9457ae96dae0ec0c9c025e6b80936e7899d641180bfef2cc0c2bb"
    sha256 cellar: :any,                 x86_64_linux:      "7fbcf5e3f40939aed48325b0a77dee4a3c192dd221ca8c91dd75e2c70bbfb83a"
  end

  depends_on "go" => :build

  # `test do` block queries Alpine package repositories
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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