class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "0e8c3c6847a8dae13d13de3c5b1e1e84cf8ce0b31120aed984971896ef58237f"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aea7d5618d4804de1144da56fac2e413009752c9c418a6ed5d81e914dbd83efe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86bf49d237ff1798d14fb584662065f21525c61981440c56c434e9bfb47a03a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2de7dd0676936aaedaacfa1b9aa3acd46cdaabc92b1c45b5dacedf671328efff"
    sha256 cellar: :any_skip_relocation, sonoma:        "078d2a39249f69617b206a18af7d61b6d52b45125a8191be4e5d35aa9898b202"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b22ec10feda0cf108505490f1f7226ffa8f85733f8aca7b38b4e7926cb42ca55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8694c976c82774771595456864530a139c242cb64ad32748a3219286551d4836"
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