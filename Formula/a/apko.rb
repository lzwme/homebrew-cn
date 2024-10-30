class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https:github.comchainguard-devapko"
  url "https:github.comchainguard-devapkoarchiverefstagsv0.19.6.tar.gz"
  sha256 "b984991fbeb01e4a183cbb3304dbab0d54729cb308d60f899645d9e929ccf2a4"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29e7c4c8eac7ffee733ad4a985ff80ab8b7d039114973ca2af42cd98773e0497"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29e7c4c8eac7ffee733ad4a985ff80ab8b7d039114973ca2af42cd98773e0497"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "29e7c4c8eac7ffee733ad4a985ff80ab8b7d039114973ca2af42cd98773e0497"
    sha256 cellar: :any_skip_relocation, sonoma:        "e27957ffa4b0c2e838538c32e9f6a6d9e5c9185e803eaa86125b78199b4dfa91"
    sha256 cellar: :any_skip_relocation, ventura:       "e27957ffa4b0c2e838538c32e9f6a6d9e5c9185e803eaa86125b78199b4dfa91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "043d7609100fcfaac7edaf19e229289a4160813f4136dbbb62ee72d1d52b8258"
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