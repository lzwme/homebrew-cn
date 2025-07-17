class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://ghfast.top/https://github.com/chainguard-dev/apko/archive/refs/tags/v0.29.6.tar.gz"
  sha256 "da52e9c22357176fed44f7fb591d3a783911af3fed3c0f1cbf7c04b21b84738d"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46f46ece437172661fae2c2439dcdd3f36b5573255afb7a28e402311863753b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f108f86fbdd000c65957b590e5a58c0b5f83d069705d017c703c1925d44ddc3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7fbc22f6fe757a4c035b0686fc18671c5795f6d89765f5b5b4d763d1c02f26d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "770a009e691f0150e55d35d6f48ca451038cc862610eb8b1fb332553631a488c"
    sha256 cellar: :any_skip_relocation, ventura:       "8bef0c86ca887038ef10674f985113a1b348b30bfd842f0575c4e21bd5e0665c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a17a56d553f910b4bae5ad716d33792c5669ae23c303bc4de36c96d259e267f1"
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