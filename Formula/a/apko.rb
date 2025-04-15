class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https:github.comchainguard-devapko"
  url "https:github.comchainguard-devapkoarchiverefstagsv0.25.7.tar.gz"
  sha256 "a6ce3bf0e23f4167cb85b46c1271abbdfc659e909cb86a0b65363eb6b736296b"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6bab101c165361f1cba6e550c53d7b9d82e37e088af3ae5afa8f00a921ef7c9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6bab101c165361f1cba6e550c53d7b9d82e37e088af3ae5afa8f00a921ef7c9f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6bab101c165361f1cba6e550c53d7b9d82e37e088af3ae5afa8f00a921ef7c9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "4506df5adf1164de048a7e7f80220b9ad74a3ce9bbf6e8320c16c18845bc6b1e"
    sha256 cellar: :any_skip_relocation, ventura:       "4506df5adf1164de048a7e7f80220b9ad74a3ce9bbf6e8320c16c18845bc6b1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b9f4a808831fff6ee9bddf7bd7e67f88e6bc688655aeef66792819e8e7df482"
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