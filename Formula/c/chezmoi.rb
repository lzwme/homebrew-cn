class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https:chezmoi.io"
  url "https:github.comtwpaynechezmoireleasesdownloadv2.62.4chezmoi-2.62.4.tar.gz"
  sha256 "bad72affd6ae99a8f4b1b54d939aa5193bd16bf1e76f11e3e84ba64f7fa142fd"
  license "MIT"
  head "https:github.comtwpaynechezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "973b48f4e2275ef5b2a7df01c7b56daeaa8a1fe1d9f9ddf5a49ed3e929926c7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5a43612434f2b0025e917c96590e75db3ab5437f19466b421fb005af971317e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f1672cb681908904884a102504839d7229e6d66a703eee7de3269b1dc728f787"
    sha256 cellar: :any_skip_relocation, sonoma:        "4748001c098015e9ee4182707521a002e6df5f719a22f5bbe1d4915528bc7e3b"
    sha256 cellar: :any_skip_relocation, ventura:       "8b2e05ff0f046be315e149a1ca1573d9d5ea0ff943ba0cce27990e77c15c8162"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4df22e5d9b93ceec50b9af01e08206b8ed32157f4cc54707a03574bbaabd792"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "991abb5170839754b65cb099f41bbf48ede386bf086af2500e220a85dae4bb7c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{File.read("COMMIT")}
      -X main.date=#{time.iso8601}
      -X main.builtBy=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

    bash_completion.install "completionschezmoi-completion.bash" => "chezmoi"
    fish_completion.install "completionschezmoi.fish"
    zsh_completion.install "completionschezmoi.zsh" => "_chezmoi"
  end

  test do
    # test version to ensure that version number is embedded in binary
    assert_match(commit [0-9a-f]{40}, shell_output("#{bin}chezmoi --version"))
    assert_match "version v#{version}", shell_output("#{bin}chezmoi --version")
    assert_match "built by #{tap.user}", shell_output("#{bin}chezmoi --version")

    system bin"chezmoi", "init"
    assert_path_exists testpath".localsharechezmoi"
  end
end