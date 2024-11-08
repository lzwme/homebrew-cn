class PhylumCli < Formula
  desc "Command-line interface for the Phylum API"
  homepage "https:www.phylum.io"
  url "https:github.comphylum-devcliarchiverefstagsv7.1.4.tar.gz"
  sha256 "6c23deb87e3ca8c3d893d8050fbf61fbbd43694daa36cd37af23c8daaf776d57"
  license "GPL-3.0-or-later"
  head "https:github.comphylum-devcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "faae0a25ba3bae571acba338b6a9159c89b4320b77017907ab50f2eb30c18908"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "557b5bcec8674c15b96549f5b3351b8fb13fc27ae66c429c6358c7326c40a430"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cf5d9cc2dfd34f41093f4ec2a83a151eb67c9e044cd08db24567fa6c4bcafa07"
    sha256 cellar: :any_skip_relocation, sonoma:        "fab5158561d5876b115f6ffc7af8afa7d16c439364434a5ea145b06ec501a054"
    sha256 cellar: :any_skip_relocation, ventura:       "b1a68dd6ab8f470403ec8a5c500e10480698c52b00fede6ca19cf26dea4e9890"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "167e4b4400a8f746a927b61a0d08eac810b2e05f118fc6ec8a5ae1f4b81c9552"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "cli")

    # Generate and install shell completions
    system "cargo", "run", "--package", "xtask", "--no-default-features", "gencomp"
    bash_completion.install "targetcompletionsphylum.bash" => "phylum"
    zsh_completion.install "targetcompletions_phylum"
    fish_completion.install "targetcompletionsphylum.fish"
  end

  def caveats
    <<~EOS
      No official extensions have been preinstalled.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}phylum --version")

    assert_match <<~EOS, shell_output("#{bin}phylum status")
      Project: null
      Group: null
      Project Root: null
      Dependency Files: null
    EOS
  end
end