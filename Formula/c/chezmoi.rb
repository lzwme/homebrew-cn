class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.42.2",
      revision: "ea1e143fe416097792706a708144ffda0d85b268"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "435dd14c8c735d35446cd6a973f99279196dbcdf2f33bbfb3626e95391956cac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b23546e5e7feb7a8a4166cbfec6e748b808b11eff98e907a043d91edbc6126fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de44762eabea27d5f4c211ec93fde8e41729b07179f3064fe66382afdd238a92"
    sha256 cellar: :any_skip_relocation, sonoma:         "598af602a732fa19be8c9f37bd0bed32d236d2673c32b7089567c601e35cfb0a"
    sha256 cellar: :any_skip_relocation, ventura:        "7ef121e40d5216da0779427fc87d57beae0e5e27fdc2a6caa9153ea66cb92cc5"
    sha256 cellar: :any_skip_relocation, monterey:       "01351090c896484400a05d2b66d880b562fc874d6d8e8ee57e074b57254b261a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f5ced7dd61cea46a3ae3dd2e43044e6c4dba2c6528a41ce2989630b0337cb8d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
      -X main.builtBy=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    bash_completion.install "completions/chezmoi-completion.bash"
    fish_completion.install "completions/chezmoi.fish"
    zsh_completion.install "completions/chezmoi.zsh" => "_chezmoi"

    prefix.install_metafiles
  end

  test do
    # test version to ensure that version number is embedded in binary
    assert_match "version v#{version}", shell_output("#{bin}/chezmoi --version")
    assert_match "built by #{tap.user}", shell_output("#{bin}/chezmoi --version")

    system "#{bin}/chezmoi", "init"
    assert_predicate testpath/".local/share/chezmoi", :exist?
  end
end