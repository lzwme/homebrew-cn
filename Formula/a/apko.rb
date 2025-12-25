class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v0.30.34.tar.gz"
  sha256 "5ff2e903667148dfab6b43982a254fa51cb9ae63332bb8f9e566a83e4d363a30"
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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "25b47788f10286de9158458845fac3da20e0f889c469eba524c62add1aee7429"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b5ca487439284a224e839af52841a7653ee9168765ea995a1a64b5dcc7523ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da4c426d4b4d98a6e779060a4e6e63d56beba1879fc775b10350a309d2223392"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ec17bc23fb1fa011d18c8e6229d8d52f2e12e26d741ebda22ef6c4b4e33435b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b755c24fe97bdeacef4fbdcff5de455b1a80cd222594c156262969ee2b16558b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3f3a129c12daa6f1c419d0c7c62bb5fa2f071e42d4ee8fdfeb13032af48802f"
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