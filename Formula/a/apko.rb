class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https:github.comchainguard-devapko"
  url "https:github.comchainguard-devapkoarchiverefstagsv0.19.8.tar.gz"
  sha256 "aa993685ba7cfefc6ed6abebd092205bb14c848b4177b93c1552b104783b80c8"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18154aa67b5ed8c16b308bb33fc84ee9dbf2c7204a93bfb0f80c0e8540439045"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18154aa67b5ed8c16b308bb33fc84ee9dbf2c7204a93bfb0f80c0e8540439045"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "18154aa67b5ed8c16b308bb33fc84ee9dbf2c7204a93bfb0f80c0e8540439045"
    sha256 cellar: :any_skip_relocation, sonoma:        "ada266f41d18de6460c109d42fedfb907013f2d52c52695f54d10bb788f5533a"
    sha256 cellar: :any_skip_relocation, ventura:       "ada266f41d18de6460c109d42fedfb907013f2d52c52695f54d10bb788f5533a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52fd97fbd625f122465f0c54f38fd96db1519025334d2f1bd55e2bd79e8d2c1f"
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
    (testpath"test.yml").write <<~EOS
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
    EOS
    system bin"apko", "build", testpath"test.yml", "apko-alpine:test", "apko-alpine.tar"
    assert_predicate testpath"apko-alpine.tar", :exist?

    assert_match version.to_s, shell_output(bin"apko version 2>&1")
  end
end