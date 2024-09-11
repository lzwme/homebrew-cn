class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https:blog.alexellis.iokubernetes-marketplace-two-year-update"
  url "https:github.comalexellisarkadearchiverefstags0.11.24.tar.gz"
  sha256 "a553a05eb0cec4cb11892bdd5163dc79d5fd053dff7a95160e652662259cbaf7"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5fa5490f0c1558acb8afbf9d95bed8ab3e4ab3c8609fd8e977f1b26abf750750"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5fa5490f0c1558acb8afbf9d95bed8ab3e4ab3c8609fd8e977f1b26abf750750"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5fa5490f0c1558acb8afbf9d95bed8ab3e4ab3c8609fd8e977f1b26abf750750"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5fa5490f0c1558acb8afbf9d95bed8ab3e4ab3c8609fd8e977f1b26abf750750"
    sha256 cellar: :any_skip_relocation, sonoma:         "a555cf1f6a2f2961baf3866ef04eaed776e38ed3f58581018cd1d195086464e4"
    sha256 cellar: :any_skip_relocation, ventura:        "a555cf1f6a2f2961baf3866ef04eaed776e38ed3f58581018cd1d195086464e4"
    sha256 cellar: :any_skip_relocation, monterey:       "a555cf1f6a2f2961baf3866ef04eaed776e38ed3f58581018cd1d195086464e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8245ee01d73fa2e3c52e0779f7a9b1ecdd7b3be2c911fc36514e368ccc2f27e7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comalexellisarkadepkg.Version=#{version}
      -X github.comalexellisarkadepkg.GitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

    bin.install_symlink "arkade" => "ark"

    generate_completions_from_executable(bin"arkade", "completion")
    # make zsh completion also work for `ark` symlink
    inreplace zsh_completion"_arkade", "#compdef arkade", "#compdef arkade ark=arkade"
  end

  test do
    assert_match "Version: #{version}", shell_output(bin"arkade version")
    assert_match "Info for app: openfaas", shell_output(bin"arkade info openfaas")
  end
end