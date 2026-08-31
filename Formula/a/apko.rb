class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v1.2.42.tar.gz"
  sha256 "ceb266633b3d3968f69bef736a0c474c3210773b7bfbcd7fc9a12e01e1c44cfc"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e256ee464733e14a93450c87e21022a27fc88d50d50bcdbcd4634cdb6f6cf78c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "adb1580dc367e50640854961abb1dd8d5a8deacd7cbbb0c9b78a5d7b0e0ec447"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84b63be23c6d3bb71c49ee35a0aba80a7b2584defbcfa7823524a0bd392be5a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbaca48a97ef602610378ff7dc35fc8d2bb10e211f8b013afdaf2809f0ae4182"
    sha256 cellar: :any,                 x86_64_linux:  "2378f87b12d4f09cedd8ac98e5788ce050126bb0ece791e559b6e8e50e8d9fc7"
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