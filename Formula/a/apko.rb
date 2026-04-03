class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "8c012956687d64ebeae18a59a26f8158f6d164d29ec37c2728a030fc741034fa"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c6e9ea42dfeab2f65f113b743b0c56bc621cea5a9707af38330af0dafc88bdbe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "edbd08ea99651950db876a134f50893801add9fd7dcf1c09363b8e25bd083c62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55f0bef13d41bc8ddb787f409a040fe7ecc6409796285a323764f3c08e742320"
    sha256 cellar: :any_skip_relocation, sonoma:        "68d48ca2a7800c63b57aa9b42ca95e29581d7d5225193a9278428d3efc37addb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0230aa5c1935ff5c7bd388dbcdaff8beb4a867c97e492d4740d8f11e86c6a492"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "661f85fcde2795d5edf5c679119d49e0fce3bdd40a256175049c0e7b7c5b7a4d"
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