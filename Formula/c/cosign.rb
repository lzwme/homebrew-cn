class Cosign < Formula
  desc "Container Signing"
  homepage "https:github.comsigstorecosign"
  url "https:github.comsigstorecosign.git",
      tag:      "v2.2.2",
      revision: "bf6b57bc3edf8deb7e225e4dbd2d26c0d432979b"
  license "Apache-2.0"
  head "https:github.comsigstorecosign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3b3984b5d8542fa94a3b212125343fc244faf05b1584abe662e0baf81c9d0e90"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9ac7c22305936ab569eac0ade9987801f8930f575fe24a50d5dfd0655073b615"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44ee532fe53c33366efbb259e8d8edf805aef0eb9506f063b3a08ceda6752f42"
    sha256 cellar: :any_skip_relocation, sonoma:         "1fbd65e53421c032af8b11b3b864e99b0acc30a84f40d3756878aef777caada5"
    sha256 cellar: :any_skip_relocation, ventura:        "38a599c803353cbca72de244f357ac3bdd65ded479740571ac57222737824381"
    sha256 cellar: :any_skip_relocation, monterey:       "1d5e9001610863a19d9b2a9b0849f1747b22ed1a38ae167436bfd5c8f4e9cf6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "485a9cfb4deb357ef77ee4d4cb8fb37b3a993488a2fcb5909113f743ab161324"
  end

  depends_on "go" => :build

  def install
    pkg = "sigs.k8s.iorelease-utilsversion"
    ldflags = %W[
      -s -w
      -X #{pkg}.gitVersion=#{version}
      -X #{pkg}.gitCommit=#{Utils.git_head}
      -X #{pkg}.gitTreeState="clean"
      -X #{pkg}.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), ".cmdcosign"

    generate_completions_from_executable(bin"cosign", "completion")
  end

  test do
    assert_match "Private key written to cosign.key",
      pipe_output("#{bin}cosign generate-key-pair 2>&1", "foo\nfoo\n")
    assert_predicate testpath"cosign.pub", :exist?

    assert_match version.to_s, shell_output(bin"cosign version 2>&1")
  end
end