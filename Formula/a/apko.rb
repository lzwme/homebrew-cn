class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v1.4.11.tar.gz"
  sha256 "3f5bdd944a57766b7e3336d81049ff21d9c7d26399cde799ec2c8774ecd7a393"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6d5a70b970489981d38a690ae01705f873e10552e3007c3b0cd24f94a37f4485"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cc8274e5093b79a880d2a85f037020c1234987223e89b4612e8078268629ce35"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "712d076865566d239f953f1f810f3a71902dbb6a47a2f921d56742742340924f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8bb3dc9545acf5fcac766a7f07e6290884f18bd0fc5e7558a9a925281c85797f"
    sha256 cellar: :any,                 x86_64_linux:      "a79e3ebf2f1416381532319a6ba25c8d324fd6eea4b3dc5e17cf4f056b61abf1"
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