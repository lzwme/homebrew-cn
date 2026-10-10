class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v1.4.10.tar.gz"
  sha256 "3bd5895fe895b767076491fbd7d554e897b5db93fa8625a904fb38615e64471a"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "380027df4c34175f9c3735f4e3d2c90b8e08e1ef452921b5f737b0b9e1336c39"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "93c53f770432937ea22fac795e8baad9ee85a59105bc6d6f7805d2f5805b932a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "12cb70d4b33a60d9c94a6c1bfeae3407ce237e0f4e4fff509fe2c17229663608"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4a9af785ac5e9d914bbf9a6960d02faca4051a0941c6dd40a9dea6e308812a57"
    sha256 cellar: :any,                 x86_64_linux:      "f3fccc2b75e19e4c4ce75ef504c422e5325af9c78bfc4192017643bd293b92e8"
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