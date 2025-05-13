class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https:github.comchainguard-devapko"
  url "https:github.comchainguard-devapkoarchiverefstagsv0.27.5.tar.gz"
  sha256 "2d1c3500e9b240fa6a2c22a08873240c042f47472e495defabe9c973b78c46dd"
  license "Apache-2.0"
  head "https:github.comchainguard-devapko.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c09f3473d9f3bb59cbb9cf2840272dafd3f73a34dd2d5e33a2f5fdb923dfb4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c09f3473d9f3bb59cbb9cf2840272dafd3f73a34dd2d5e33a2f5fdb923dfb4f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8c09f3473d9f3bb59cbb9cf2840272dafd3f73a34dd2d5e33a2f5fdb923dfb4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "86cb11df89d8d0d100b327083e3709097b024619a74e5fc4fa719ef35ac39a8b"
    sha256 cellar: :any_skip_relocation, ventura:       "86cb11df89d8d0d100b327083e3709097b024619a74e5fc4fa719ef35ac39a8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6299ac868483a3e0f59c8c745d59b5449e5476f9a22d85c9a0c88238a5be1a0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.iorelease-utilsversion.gitVersion=#{version}
      -X sigs.k8s.iorelease-utilsversion.gitCommit=brew
      -X sigs.k8s.iorelease-utilsversion.gitTreeState=clean
      -X sigs.k8s.iorelease-utilsversion.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"apko", "completion")
  end

  test do
    (testpath"test.yml").write <<~YAML
      contents:
        repositories:
          - https:dl-cdn.alpinelinux.orgalpineedgemain
        packages:
          - alpine-base

      entrypoint:
        command: binsh -l

      # optional environment configuration
      environment:
        PATH: usrsbin:sbin:usrbin:bin

      # only key found for arch riscv64 [edge],
      archs:
        - riscv64
    YAML
    system bin"apko", "build", testpath"test.yml", "apko-alpine:test", "apko-alpine.tar"
    assert_path_exists testpath"apko-alpine.tar"

    assert_match version.to_s, shell_output(bin"apko version 2>&1")
  end
end