class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https:github.comchainguard-devapko"
  url "https:github.comchainguard-devapkoarchiverefstagsv0.29.1.tar.gz"
  sha256 "f7c446fca31b5e1933875f2c17e881885f034fc801ef8893d8a3883e66aaae7d"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63b934003a45e7710a5dccf66dc5f94105244b48b2e60344791b2e0d46eb45ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9caf6e2dcc813dcfc7a956e6d379317a83221ea67832c20270b8a731e6ab2637"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "31fb7e6c75f8ab222139c9cd1242fd7f4fc17323ac07e2f1b50d0a0685195c95"
    sha256 cellar: :any_skip_relocation, sonoma:        "31df8412d202c93b1f5eefcaef88ff850c9a154181fe22192e01a31d8603e67f"
    sha256 cellar: :any_skip_relocation, ventura:       "43c717cb73a576f99b7e4978a6ec06ace6c6824f14dc59c88b0d2a343e0ad8b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "087c215b4add290152efcefdaa891a33d760b8f47b04b057ffc1d95ff148e712"
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