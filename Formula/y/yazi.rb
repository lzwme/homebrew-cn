class Yazi < Formula
  desc "Blazing fast terminal file manager written in Rust, based on async IO"
  homepage "https:github.comsxyaziyazi"
  url "https:github.comsxyaziyaziarchiverefstagsv0.3.2.tar.gz"
  sha256 "6aec4ed553670a47b3e5b34c161bb4356b1ebfac084b7354cd26052a81f971a4"
  license "MIT"
  head "https:github.comsxyaziyazi.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bb664cce271605950c3d8f7d9d59b57c3f9ac9db393e73656f1127aea5cad7f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "99966d00c59e94f0f9504ec21b638e92a2e96541596e0692b73925528c9b7e52"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "260586475ba8a6303ef966df1d0d0407ec1b4d4ffba65eb60ac0490301debf47"
    sha256 cellar: :any_skip_relocation, sonoma:         "fc89575f418b7beb5499381fa7fef49e373612af7e59a074f750d797d63aa18c"
    sha256 cellar: :any_skip_relocation, ventura:        "8116ef09c6d8961f09841e640fb4a672c90dbc5e19624eeff08cad6a9229e183"
    sha256 cellar: :any_skip_relocation, monterey:       "2cbc5c9dceed46c523fab8caa8782f0641f10b474e80c33918de0fe76a2c6623"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88e10a4fbf3ccf07c93e0fc955f99456964c32598b7d760f08011df9a2f3f8a1"
  end

  depends_on "rust" => :build

  def install
    ENV["VERGEN_GIT_SHA"] = tap.user
    ENV["YAZI_GEN_COMPLETIONS"] = "1"
    system "cargo", "install", *std_cargo_args(path: "yazi-fm")
    system "cargo", "install", *std_cargo_args(path: "yazi-cli")

    bash_completion.install "yazi-bootcompletionsyazi.bash" => "yazi"
    zsh_completion.install "yazi-bootcompletions_yazi"
    fish_completion.install "yazi-bootcompletionsyazi.fish"

    bash_completion.install "yazi-clicompletionsya.bash" => "ya"
    zsh_completion.install "yazi-clicompletions_ya"
    fish_completion.install "yazi-clicompletionsya.fish"
  end

  test do
    # yazi is a GUI application
    assert_match "Yazi #{version}", shell_output("#{bin}yazi --version").strip
  end
end