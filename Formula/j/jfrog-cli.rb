class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https:www.jfrog.comconfluencedisplayCLIJFrog+CLI"
  url "https:github.comjfrogjfrog-cliarchiverefstagsv2.71.3.tar.gz"
  sha256 "e5154a1d2afa91735ed000fa3ae37afbe33f49a328c665047c6af1afb4d0540e"
  license "Apache-2.0"
  head "https:github.comjfrogjfrog-cli.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9cec12d2473c068e5807881d14fb7c163200a90c6b4bb136f7c38a08f3465bab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9cec12d2473c068e5807881d14fb7c163200a90c6b4bb136f7c38a08f3465bab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9cec12d2473c068e5807881d14fb7c163200a90c6b4bb136f7c38a08f3465bab"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ead971c4bacaa0cd543c40da435ea727ea189002b10ca3a4d11b2422ff95494"
    sha256 cellar: :any_skip_relocation, ventura:       "7ead971c4bacaa0cd543c40da435ea727ea189002b10ca3a4d11b2422ff95494"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f73017ba1a65635c5263b0e4ca0655d46b9fb8a43b91c84e3c2de13cc48deee"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin"jf")
    bin.install_symlink "jf" => "jfrog"

    generate_completions_from_executable(bin"jf", "completion", base_name: "jf")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}jf -v")
    assert_match version.to_s, shell_output("#{bin}jfrog -v")
    with_env(JFROG_CLI_REPORT_USAGE: "false", CI: "true") do
      assert_match "build name must be provided in order to generate build-info",
        shell_output("#{bin}jf rt bp --dry-run --url=http:127.0.0.1 2>&1", 1)
    end
  end
end