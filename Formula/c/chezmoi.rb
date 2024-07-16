class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https:chezmoi.io"
  url "https:github.comtwpaynechezmoiarchiverefstagsv2.51.0.tar.gz"
  sha256 "70c0c7887a42bcd77fe33faa7ba546b7eb4e933bc68065b0028de4146738ebce"
  license "MIT"
  head "https:github.comtwpaynechezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1b432c20435283395b546d095b05e150079d8e6e0a16f757f3a4e68f65dabf6d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2cee6d60962c265fc56999c07d425230d350ab7a68dca9a89d1313d7ddfa2d7a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2abcbb8f216a51463ebbb1895ec2838c708a6f67b4a6965aaf73ce232326aff6"
    sha256 cellar: :any_skip_relocation, sonoma:         "29472f9cf3298e1c3153402ff78d50cfc9e8064a40005686bb7945948d68f3ee"
    sha256 cellar: :any_skip_relocation, ventura:        "7222ac8c88646b21f8d15d39a5752388edf0d9520e3e8836e6063b357282346f"
    sha256 cellar: :any_skip_relocation, monterey:       "9d05dddd861af742ba50a46d68b9b7f275f55cde5c2d3815173efc4157e07512"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "438ad78448d5e116ad32d5b4a740fc04bfb3c55717bea80fb579bdaa9cd93801"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
      -X main.builtBy=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

    bash_completion.install "completionschezmoi-completion.bash"
    fish_completion.install "completionschezmoi.fish"
    zsh_completion.install "completionschezmoi.zsh" => "_chezmoi"

    prefix.install_metafiles
  end

  test do
    # test version to ensure that version number is embedded in binary
    assert_match "version v#{version}", shell_output("#{bin}chezmoi --version")
    assert_match "built by #{tap.user}", shell_output("#{bin}chezmoi --version")

    system "#{bin}chezmoi", "init"
    assert_predicate testpath".localsharechezmoi", :exist?
  end
end