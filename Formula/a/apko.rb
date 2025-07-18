class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v0.29.7.tar.gz"
  sha256 "72d91c17f493405c8cb873d7b42c50ee8826b3cfeea91f194ffc5eeb086cbde5"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f90f5ed53cc8520bfb7be178a0044685c817e75af754465a248c2fe05658f45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7819e17bfb20839182b7d39c217eeb3f98148f3368bb967037d13f8ca469f2cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "976849e12483faf1f6009509aab165a1c5fbee0339efe9a94549dc4378f908fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "f814b809c43f675fbe1305ef9885458daf8bfa8a292fe19cac83455bb2109604"
    sha256 cellar: :any_skip_relocation, ventura:       "746c60294fc4776a1ab29650f0ed8cab2f235b0cb7663bc954bcc2b6354e978f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2693bd17ca56c09a52e466454a920c4fec12071beb6781ff915ff3300d049960"
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

    assert_match version.to_s, shell_output(bin/"apko version 2>&1")
  end
end