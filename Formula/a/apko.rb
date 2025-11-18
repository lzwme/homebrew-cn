class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v0.30.23.tar.gz"
  sha256 "d3b7f96ea691080d7d3b5e055dbada7acbf70d912be0b4f310fb1103d17bc0ee"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "106148de5c2a0ba63c02d4509d205d159d1cad16d56a706a56c261aaa294fbf1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "acbf96682e551a9f1be29d8cc879ddfdae1bd0e7b84dcdc43dd098a3d6b726b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87ed4bd18fbb8ec8f44237d50642283d98c1bd7216a8353d8a3c25fa75b4591e"
    sha256 cellar: :any_skip_relocation, sonoma:        "4fddaf59e3a768a73dbcc1f396944d764bf0eab0281dc8bec6bf7aaf20c5f5ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e0b036a6c4d17d4db3a3a1f9373f7a19cbca99fb20c62480b9ff6b842ea80c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43bea31cd1b2a9a75545aecbe63e6be37cafa4e199e62f34b78e2f9a29572bde"
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

    generate_completions_from_executable(bin/"apko", "completion")
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