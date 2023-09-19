class Falcoctl < Formula
  desc "CLI tool for working with Falco and its ecosystem components"
  homepage "https://github.com/falcosecurity/falcoctl"
  url "https://ghproxy.com/https://github.com/falcosecurity/falcoctl/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "2e40d351a29fdf7fee8baa194ddbc3b1a53a1631666ec5d4051b21a55dd8907b"
  license "Apache-2.0"
  head "https://github.com/falcosecurity/falcoctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a3141a736c359763582a218fd85774c9d5d230492613d02c4c58132b8bd683bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a90af7ff6c9aee113ebd2b085c18ae6534660c1a8db94aa93e00f95f713e542"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f261e6511d710e602d1dc329f6af0c27d3242071f6f8825ea87897609eb2cec"
    sha256 cellar: :any_skip_relocation, ventura:        "dde359a9d5cb54fdbd14625a21caacf20ff06f8e7c00d7d70e0ebd7b3cf4da53"
    sha256 cellar: :any_skip_relocation, monterey:       "545d01a5a705690f3be20a3e33b886b7f002784f9bac2195cdaa1f2716ed5576"
    sha256 cellar: :any_skip_relocation, big_sur:        "7ab3f6243db917d2c2eed7acf4f12f5261f38558af77e860a7ed5d18824f9b64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3de1c682d9bacdda13f40f74cb58d28010bcfbcb71adfaa29a1572d77941726"
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