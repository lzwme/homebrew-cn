class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v0.30.21.tar.gz"
  sha256 "31f3e3ab51e225aa9cafb0d3dff9136170cf32ab70667bf8ae09eed9117beaf2"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37215d6f1c28454cd1bb438cc2f0fe114a8744f563200592900beb547b77ae70"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72b4f3150af46609e9aa2509d34a9f448b91b9c4f7c4aedab4732f52f7dab0be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7027f2641ae55a74102ce4efd29689c5638dd8d42436400ebb25e747957080df"
    sha256 cellar: :any_skip_relocation, sonoma:        "bde91ebed5c9a4e0ea8138a1e5cf29b139590d5e11b8ec3403d112e674825031"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a81632857067de011b992c97288997f2be737ae3bfcd749e6a61d45e00aa362"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4c33692dce21f88ee215d0c55ae3c3c41a835c0d3055bdeab206e260bb5e8dc"
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