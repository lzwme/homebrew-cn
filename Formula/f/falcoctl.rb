class Falcoctl < Formula
  desc "CLI tool for working with Falco and its ecosystem components"
  homepage "https://github.com/falcosecurity/falcoctl"
  url "https://ghproxy.com/https://github.com/falcosecurity/falcoctl/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "515a856b84493c06c40d93b86ab2a7dbb47d871e977b608e5fb911be0fc2f2f2"
  license "Apache-2.0"
  head "https://github.com/falcosecurity/falcoctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e670b84f4d10a4f96794e794e96eafa551abfce3baaa6ef4f8ab4b9af887afbc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c46b30e3fbc7999843fcb40dd450bfd1c21aa258108a9e35d1ff03b4ad68864"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c68f9d43a7e3bcf7b1854a6fda45a1a781311fe57ccac93c0c10e5802e009af2"
    sha256 cellar: :any_skip_relocation, ventura:        "a775529f16dc5aad08865c5930e4a28fcc404da6258fa98276f009353db98ccd"
    sha256 cellar: :any_skip_relocation, monterey:       "a2f6fa72d5c7e7ef9f266aeeca973e090c1571842e8074fdd831094cc3c47987"
    sha256 cellar: :any_skip_relocation, big_sur:        "8a0eb09e6c83a0a14c88085fdbe35c4fd96902a6cdf5d299ba7112360768ed6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c20c38820e3a871e8e73791570453c19ec321c7e5e6b8edd2158f95a1c69e3b"
  end

  depends_on "go" => :build

  def install
    pkg = "github.com/falcosecurity/falcoctl/cmd/version"
    ldflags = %W[
      -s -w
      -X #{pkg}.buildDate=#{time.iso8601}
      -X #{pkg}.gitCommit=#{tap.user}
      -X #{pkg}.semVersion=#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "."

    generate_completions_from_executable(bin/"falcoctl", "completion")
  end

  test do
    system bin/"falcoctl", "tls", "install"
    assert_predicate testpath/"ca.crt", :exist?
    assert_predicate testpath/"client.crt", :exist?

    assert_match version.to_s, shell_output(bin/"falcoctl version")
  end
end