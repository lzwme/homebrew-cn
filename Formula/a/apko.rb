class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v1.4.5.tar.gz"
  sha256 "ab42d6696f5ea6644b9d7d8196d5dca11ab7649d9ff050b430ce8f8117101744"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3a480ce7065126011b8c48f7181e2ec7dad8481d88095644e616fa8237027203"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "914ac1328b9577d63fec465682ffa8e3d932355396669a65cccf8e861a2e0c8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "282a79983f88e5fa900669f2edd4afa7496d70def603ecc0a85649020ca87749"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "23daa4f794b404f6b08bb0050dcb004410c67079d1156bbb09dca8143402a060"
    sha256 cellar: :any,                 x86_64_linux:      "0cdbee21389a002ee57eb2f3763ba3f35807a9e2475057f5ee44151187557e8a"
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