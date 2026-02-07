class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v1.1.6.tar.gz"
  sha256 "82430119c767caa1c7199341b2254d9222581ac6c5fa5117fbf36f474138c6e5"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c5583e86bafc458e3e6140a57d3cef6e08d4c5a15222826ce758bf0a081f3bdd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f51568e2f355adca9c0bed161df646861ee04a54dbbd2a629c472611f197ce03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6bf78855c81e2d6d243c6e158b7f51b6ff05d28b38c279431826438cdc0397d"
    sha256 cellar: :any_skip_relocation, sonoma:        "3af7dd179fc0b24e57bad4e5fec686bda9873852dd79d337c76c4e137e9e5139"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef7d7b2ea8f5afecd4af16af0b3d962307ebd48db3f55500de5dffb71b7f3ec9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8c8e81472b63d8465c7600cf7a569439154eb464f9d97c79f1c9dba35c858bf"
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