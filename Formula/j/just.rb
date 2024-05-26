class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https:github.comcaseyjust"
  url "https:github.comcaseyjustarchiverefstags1.27.0.tar.gz"
  sha256 "3f7af44ce43fef5e54df2b64574930e036baadae4a66645e996c4bb2164bf2a3"
  license "CC0-1.0"
  head "https:github.comcaseyjust.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "736b79970b27602f506f2313e89cf803af656597e59d77d393797cb68b48e281"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "92ba8e4e21c991eaa05377d40ee6309a6d144b896ee9a7e0bd13b1d36e4c309d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10d0b36a941c7b816df05dbb322713b3599a8b26f29ddf6dab29a2e552de094e"
    sha256 cellar: :any_skip_relocation, sonoma:         "04f385b01b3cf770339b31b1d88a532a826e4149908d5ec72d6b045f313e8cbc"
    sha256 cellar: :any_skip_relocation, ventura:        "56b65701af703c47a53b4bb254d396398ffdc1c413473f8715b27653cba37211"
    sha256 cellar: :any_skip_relocation, monterey:       "afd51d05fc4ff82976e5e65e55d4af56cd33763cd04510e4f2ab34255411978b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3289dac0ac10d69e58f5e07945a75a1031a9841bf8ec56f959ead55b7cf3406b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    man1.install "manjust.1"
    bash_completion.install "completionsjust.bash" => "just"
    fish_completion.install "completionsjust.fish"
    zsh_completion.install "completionsjust.zsh" => "_just"
  end

  test do
    (testpath"justfile").write <<~EOS
      default:
        touch it-worked
    EOS
    system bin"just"
    assert_predicate testpath"it-worked", :exist?
  end
end