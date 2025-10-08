class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v0.30.15.tar.gz"
  sha256 "1191814f1689a6a6f59e28a8d5a61b0760140beb70adea183f7c54f688e5a416"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d6358fa473920ae4cd1d6f6cef3c48bd8cb242162f080e4c2a46b0f245c79317"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02844978f776e132ecd24ba972064e6a9d5bf54886bdcde19561ca9d0fd8772a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6c27e53fb9774352045a6c16a03174881a852904aea34c3eaef49d75dd497c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "615369373a0a32974b7598ea60136d0cb37156d93437e184e601ade9666d968f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b53b343424557e937aa740c78009295bca8f9822fc64d60d0020cd2e66427de"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.io/release-utils/version.gitVersion=#{version}
      -X sigs.k8s.io/release-utils/version.gitCommit=brew
      -X sigs.k8s.io/release-utils/version.gitTreeState=clean
      -X sigs.k8s.io/release-utils/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"apko", "completion")
  end

  test do
    (testpath/"test.yml").write <<~YAML
      contents:
        repositories:
          - https://dl-cdn.alpinelinux.org/alpine/edge/main
        packages:
          - alpine-base

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

    assert_match version.to_s, shell_output("#{bin}/apko version 2>&1")
  end
end