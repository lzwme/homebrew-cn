class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v1.2.38.tar.gz"
  sha256 "854198dd152b1a1c959648294722e8fab5624a2cc3977131698b6aadd1f00a17"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b191e4e13459f70c4e1c95c2927951c47514aea5aacfd1ecdb64493556f27cfe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5398bb479a65a7c0ec485bbc13b1d8088d45506e229ce5989be308f3da3f573a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8e8f44aaf2c9131a8b22e9971b96fb39a3c2cd64f79c4ec6fba4d054a7af693"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2b35f0b4c8e814e6682d5c5d6605d88d03d2e91c9d39137e51c9dbecf21acc9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ec3de5eaac45433b0d4db4fd800147b4e4de2699b1af79e99880846231da69d"
    sha256 cellar: :any,                 x86_64_linux:  "3c90a0f52bf3caadb2090590f443952132ad03b3155b30a848eddb3d5e874985"
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