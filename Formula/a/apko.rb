class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v1.2.21.tar.gz"
  sha256 "42a6b5c95bc9266fa40b8da7b20e2612a4e2403a71628c3be5da96c414408dad"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16405b1b987e1ae5c22011f27103839e68c2485b0900cf5e427a6d30d932fbf1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb9f48e911d5bde355e7d7c312adf31f75114933a3de120a43991a2e4dd659d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78ced13f3a2b398dde63c19bc65231dbcedc4a93f05b3ecc5b7fb48ee5cf2071"
    sha256 cellar: :any_skip_relocation, sonoma:        "8784308eda2024b6d06676d1c693035f61978ff1556efd937b53814fbec8e3c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e344da304dce3fc2b675d455926da4588482dea28b12baf2c9bb3a330a6965ce"
    sha256 cellar: :any,                 x86_64_linux:  "c1f0a778573d6b31e008de86e284e004a7c51855e4a83eb80068fed7f6852dfb"
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