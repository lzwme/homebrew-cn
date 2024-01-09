class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https:github.comcaseyjust"
  url "https:github.comcaseyjustarchiverefstags1.22.1.tar.gz"
  sha256 "525bd3fc190b508d885af1d9c01fc774b0e6cbdd0ac4a3d84606dfc5757b4910"
  license "CC0-1.0"
  head "https:github.comcaseyjust.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "03fc34c1604edabe9e6bd2fdd56e8f7586ba6e0ea5cd8c006cd7ad32facbf91b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "71930ae1e1b94491b45e2bf3b979089db492c72eb61970b205adb617017dd4b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cebe30e78e43bd9897c0fd967ba2ee8a2a305c2aac61f6a96355fae7ada84d52"
    sha256 cellar: :any_skip_relocation, sonoma:         "11b2b23d4f90b9db9c03a0fc5d49cd12e6fe0fb74227e81cbf0956c087e7780e"
    sha256 cellar: :any_skip_relocation, ventura:        "f6c0509419a0639cf4ed5085677ec15acc6cf6be0c48814dab511509eb5aaad4"
    sha256 cellar: :any_skip_relocation, monterey:       "44f250c7c1b9459d216dbde49a355de0718e8dbaedae0699a1c43d85fe629824"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "647511b54bfbcae9dbd54374395b3a84cfb1548f07f447d60dab7e08630e9988"
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