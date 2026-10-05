class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v1.4.7.tar.gz"
  sha256 "008492b64ae3b0c4f12a6269c5a347b0a542f522b424cb47d7209fd741a12622"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "48dbc0bedfdfa3adf8c9a7a105da6de0b07d3891dc94863fa68ae0a5fdf0eaa9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8b5ef9a5dfabe28fba8f5377a26f906ccf9fcb5f37b88d85bb9c2844a8c5328b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ab4c0e76f62be2c980c5487b6fb5ede6a0f49bdf0938b566ef47365f96688247"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "640b475f760772156b3bf48a3f75dba2b080bdaea4e750c60e8dbe7a964866e0"
    sha256 cellar: :any,                 x86_64_linux:      "fddcfb780bcb684d7d514a4653b1aecee3409e0cee9b3f2cb890fcad703c25e6"
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