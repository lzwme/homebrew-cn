class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v1.1.7.tar.gz"
  sha256 "88a10dcaac8d9cabfb9b41b8a64a7b4f14f92b4003ed1c4f1c520246bd9cde3f"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a342057166894b2c808fa019e1c3ed4f23deaa86316ddf7e1076d9f889346412"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8aa6cc5fe9d7413d8e0c9f65b923792457b1a899dd70987f9f804f5a61074c54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26c2da28c984090003bb08e8fca28ebdbc82bafc066b0efb428b89079e814a5b"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a25c97342416bc89c1b1119fc153f1c4bb56cd77e1921ef1280186054f041cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "000b43bdc0062a3e151b9d8e806c6863a746664c77c504ba772c5dc833018b13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c653be2d5e0d51b70e147671b4aee8ba7c46c84a308aac5b1d1ea9ccf39854e8"
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