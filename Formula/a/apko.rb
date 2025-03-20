class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https:github.comchainguard-devapko"
  url "https:github.comchainguard-devapkoarchiverefstagsv0.25.5.tar.gz"
  sha256 "02aba5d22e45feabfebb0a21a7dcbbe98b6e0a42efe3ecfda31e2702bfe56be2"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a813c0ced62b5f78c92cb3992ab65247838292fe0c8351f5ed5a1217a20c4d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a813c0ced62b5f78c92cb3992ab65247838292fe0c8351f5ed5a1217a20c4d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7a813c0ced62b5f78c92cb3992ab65247838292fe0c8351f5ed5a1217a20c4d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "b92c1ccdef7c0fba6e99aa1a7c2a07a7a1711fdd7baffee4df0e741fefacbaa3"
    sha256 cellar: :any_skip_relocation, ventura:       "b92c1ccdef7c0fba6e99aa1a7c2a07a7a1711fdd7baffee4df0e741fefacbaa3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3a56dffda7f04db02c785aab8923468c7150755736e2d272f01df1f0803c5fc"
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