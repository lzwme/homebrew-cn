class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https:github.comchainguard-devapko"
  url "https:github.comchainguard-devapkoarchiverefstagsv0.25.0.tar.gz"
  sha256 "e940bfdb308d6c78d9a97ff3c246f4afecfd21f8b7f4f1b49c3e51b6293ae407"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c88c430a0ecf339c398579bc9e667361c63e6c08a141474fd7681f106bab9c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c88c430a0ecf339c398579bc9e667361c63e6c08a141474fd7681f106bab9c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5c88c430a0ecf339c398579bc9e667361c63e6c08a141474fd7681f106bab9c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b22e3f45276a041e9c664f06ce1aac567aca2bedf97e57152e83e2078cf13b2"
    sha256 cellar: :any_skip_relocation, ventura:       "5b22e3f45276a041e9c664f06ce1aac567aca2bedf97e57152e83e2078cf13b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d381d87c287e7f950b509a04cd2b98dc67cfb91711fdf0c67c9951671a33167b"
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
    assert_predicate testpath"apko-alpine.tar", :exist?

    assert_match version.to_s, shell_output(bin"apko version 2>&1")
  end
end