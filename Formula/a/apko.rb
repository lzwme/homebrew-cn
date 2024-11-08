class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https:github.comchainguard-devapko"
  url "https:github.comchainguard-devapkoarchiverefstagsv0.19.9.tar.gz"
  sha256 "a891956998fa0070ca93a8b7abf2301ec500c2a4eaa3102a0d608f55c7b067c2"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05ac9c126e888014b65b0b3bee0ebdf0ed24a316229154f31d7a5291399610b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05ac9c126e888014b65b0b3bee0ebdf0ed24a316229154f31d7a5291399610b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "05ac9c126e888014b65b0b3bee0ebdf0ed24a316229154f31d7a5291399610b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "f56b027b0fd978db96eb8d7cebab7999e3f0013d7780fcb9a4b50a91f847dbc7"
    sha256 cellar: :any_skip_relocation, ventura:       "f56b027b0fd978db96eb8d7cebab7999e3f0013d7780fcb9a4b50a91f847dbc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac66c8f314663467379baf645811d7ee14e6199731805ef59d55fcab3153ac05"
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