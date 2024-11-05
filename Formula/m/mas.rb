class Mas < Formula
  desc "Mac App Store command-line interface"
  homepage "https:github.commas-climas"
  url "https:github.commas-climas.git",
      tag:      "v1.8.7",
      revision: "4405807010987802c0967bbf349c08808062b824"
  license "MIT"
  head "https:github.commas-climas.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f79bc1592e59900e5f876a255259a0aed774069109e2b608ffcac46bac66b52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5bae1f14f8522dc16f69b00371ae12221b6550456dd12ed0238df72cdd68f20e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e3a4df50b78219917927a482dfde491edc3524d41211fea9e507ac7a47700b1c"
    sha256 cellar: :any_skip_relocation, sonoma:        "7915e683c7579d8289934b4eb162997b74ab0cf0ad8378dd6158872965f07cdf"
    sha256 cellar: :any_skip_relocation, ventura:       "a7862ed579d42f662bbb41d4611452444e3cecfe747c09774a2cbdfd844c448a"
  end

  depends_on :macos
  on_arm do
    depends_on xcode: ["12.2", :build]
  end
  on_intel do
    depends_on xcode: ["12.0", :build]
  end

  def install
    system "scriptbuild"
    system "scriptinstall", prefix

    bash_completion.install "contribcompletionmas-completion.bash" => "mas"
    fish_completion.install "contribcompletionmas.fish"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}mas version").chomp
    assert_includes shell_output("#{bin}mas info 497799835"), "Xcode"
  end
end