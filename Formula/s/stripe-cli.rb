class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https:stripe.comdocsstripe-cli"
  url "https:github.comstripestripe-cliarchiverefstagsv1.21.5.tar.gz"
  sha256 "686fa158b5379e09b40e22efe262ef83823ae307ac34e0a610f4511d7c7876b0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c756e709efefd14e575c73b6f884e2a1d34dc7e8a79571c5c84585ffcda28017"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4eab747434250cee4fb894be0156db520cd39868c0ea0683a0f0791dd5a23c8e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b91a0b5d703fb0f14375faafcef3839848801cf9bd54c40ccd4710aaef658bd9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd5f9e7cba7d1e59bace69466968b5fc3dcdb814e841b51a96b5f6f2a9cc483d"
    sha256 cellar: :any_skip_relocation, sonoma:         "15d8ab8b769b7b9b4f68904ee4372f8333da05b548f7f9c40172842fd2d4bb61"
    sha256 cellar: :any_skip_relocation, ventura:        "111fc1b36a1e88f5c9fbe25abf646ecabe317312fd2238f898fb50a1a4a3a650"
    sha256 cellar: :any_skip_relocation, monterey:       "85e0e995e652a3bceb52de478dbcd06f83cd6e684bc5136a9033a4dfbf9921e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2734f28366a3ea2a2ed5d5cad60ebd3ab83a19dc56a1bc0bd3d77397c078a974"
  end

  depends_on "go" => :build

  def install
    # See configuration in `.goreleaser` directory
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[-s -w -X github.comstripestripe-clipkgversion.Version=#{version}]
    system "go", "build", *std_go_args(ldflags:, output: bin"stripe"), "cmdstripemain.go"

    # Doesn't work with `generate_completions_from_executable`
    # Taken from `.goreleaser` directory
    system bin"stripe", "completion", "--shell", "bash"
    system bin"stripe", "completion", "--shell", "zsh"
    bash_completion.install "stripe-completion.bash"
    zsh_completion.install "stripe-completion.zsh" => "_stripe"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}stripe version")
    assert_match "secret or restricted key",
                 shell_output("#{bin}stripe --api-key=not_real_key get ch_1EGYgUByst5pquEtjb0EkYha", 1)
  end
end