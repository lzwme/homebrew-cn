class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v0.29.4.tar.gz"
  sha256 "bdf5db49f38e2faa1ed85862e194611a4004a8b016144bc52588a1af465d0b76"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b1af0ab914313eaf6787814096708fed92e532a0647f9bb79c6d3c9dbbb682c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a851acde1a645eab8e30c76b35ec404b58cdded6d99e50d13830100a57ddc05"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "75a81cf687e88f484b796d47517c28cf58cafd25397efbae41dec7fa0cd0e80c"
    sha256 cellar: :any_skip_relocation, sonoma:        "199a1c2de2ff7e83120dc2cc141fbb7c9a4e9570ffc635d37bd9eb73b754a849"
    sha256 cellar: :any_skip_relocation, ventura:       "f74456fd057d88b37963c0e016e3558dfb00d7e733100d8b0b54619ddaa8c503"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bdd08ddd11637165171e9f7abce75e8c9ed6de0ab789421e25c0b3619a4553bb"
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