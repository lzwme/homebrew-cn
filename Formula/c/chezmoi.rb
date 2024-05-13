class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https:chezmoi.io"
  url "https:github.comtwpaynechezmoiarchiverefstagsv2.48.1.tar.gz"
  sha256 "6c7647bd42dcda7370a85c3f744018667e4a122a227ac368373443dec694d6e9"
  license "MIT"
  head "https:github.comtwpaynechezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0e455ab73da6d2f3247a7ff590d71b10ef8c0129639b78fe3606cc35168e7e2c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5b072a946e0fd4897b54501eb20f96224704dac743602b24aa7e878fbab587e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2b7ac91f44627cbeb264d73673c39c929fad56b7f9ca2b3974b7653874e2be1"
    sha256 cellar: :any_skip_relocation, sonoma:         "4d91514bc1450a6997a67319f26ca0970e4437b06749c9c526cc9e5921af3217"
    sha256 cellar: :any_skip_relocation, ventura:        "31c7a7be28d8c3dbd822b318b1a02f7269eefbed360de6249deff5b7a04e735b"
    sha256 cellar: :any_skip_relocation, monterey:       "9ea01f0bdaa484fdcb13b690856483480ab9cea840bc388dd5c0cb86ed685951"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c90a77237cbe393a46ffd03903eedafe8045aa8be4ce1dd02f789aabb825f33c"
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