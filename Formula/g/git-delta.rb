class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https:github.comdandavisondelta"
  url "https:github.comdandavisondeltaarchiverefstags0.18.1.tar.gz"
  sha256 "ef558e0ee4c9a10046f2f8e2e59cf1bedbb18c2871306b772d3d9b8e3b242b9c"
  license "MIT"
  head "https:github.comdandavisondelta.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "419f5a44407ea3cc9d236282deff3b8c6ba6f60c7689f894cba2c1faefb2fc8a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1518063982216ae94f97d54bd35655eabed9b620d4dee5919590fedac74d644e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90dce0b48166745f63dd6834a4b6d8a22097e9d3873ae140481c529a31df9acd"
    sha256 cellar: :any_skip_relocation, sonoma:         "da5130975e5ba42a3fad8fd118ae8dc638d1472e1d4a360f7559c742f13429c6"
    sha256 cellar: :any_skip_relocation, ventura:        "fb88e41696bfa3a4cc0ed0279e82a880a017d9485efa4566443570b2d30ba0fc"
    sha256 cellar: :any_skip_relocation, monterey:       "cfbca03dd73aeff305cc200c0aaa363e438466dd1c62a7a351265c8a62f3c4a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a81ec2fc6d30cde5b848927701f3308ebe2ec2bbeb233b6ac644122ad88df888"
  end

  depends_on "rust" => :build
  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
    bash_completion.install "etccompletioncompletion.bash" => "delta"
    fish_completion.install "etccompletioncompletion.fish" => "delta.fish"
    zsh_completion.install "etccompletioncompletion.zsh" => "_delta"
  end

  test do
    assert_match "delta #{version}", `#{bin}delta --version`.chomp
  end
end