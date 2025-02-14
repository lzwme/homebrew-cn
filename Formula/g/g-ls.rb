class GLs < Formula
  desc "Powerful and cross-platform ls"
  homepage "https:g.equationzhao.space"
  url "https:github.comEquationzhaogarchiverefstagsv0.29.1.tar.gz"
  sha256 "4fe266041651c8d5abcfec56bb5062e2f99e404b385b5aa2b7de65eea3f0a051"
  license "MIT"
  head "https:github.comEquationzhaog.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1083c9d7c4e002788459254db9f362e49d0ada5780b797dad28f85e3ff7a6f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36b418429e6c838fc5ff361f832fc9826b2ccddb17a2bb233b25b4ddecf45111"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fc3f3e5295c3ea3e69a254a401b6c29fda49f83b861f97aa46712751031986ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1f72abad3fb4a29fda1812c5a33e90d92325640b46d6883525ab742d0387172"
    sha256 cellar: :any_skip_relocation, ventura:       "fb589cd8f4ae33ec91255a807abfc286fea9715c8f12c9f63bca9f0a8f84b559"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a75d1483e0ebdf2495b8655d639c89faf3c544e6e449a963e4be31f2b4457207"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin"g", ldflags: "-s -w")

    bash_completion.install "completionsbashg-completion.bash" => "g"
    fish_completion.install "completionsfishg.fish"
    zsh_completion.install "completionszsh_g"
    man1.install buildpath.glob("man*.1.gz")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}g -v")
    touch "test.txt"
    assert_match "test.txt", shell_output("#{bin}g --no-config --hyperlink=never --color=never --no-icon .")
  end
end