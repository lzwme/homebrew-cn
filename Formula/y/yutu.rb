class Yutu < Formula
  desc "Fully functional CLI for YouTube"
  homepage "https://github.com/eat-pray-ai/yutu"
  url "https://github.com/eat-pray-ai/yutu.git",
      tag:      "v0.9.9",
      revision: "3bbf6c1312ec30663b6a45d23397ec06022d1c4e"
  license "MIT"
  head "https://github.com/eat-pray-ai/yutu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4781bde139db6547ea67f1fc217e47ce4f947873bb8f89ea6b4e80ad3c74dd43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4781bde139db6547ea67f1fc217e47ce4f947873bb8f89ea6b4e80ad3c74dd43"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4781bde139db6547ea67f1fc217e47ce4f947873bb8f89ea6b4e80ad3c74dd43"
    sha256 cellar: :any_skip_relocation, sonoma:        "e735997feac41cf87e25cd38df9005fff6f6215829024de798391b92cae11764"
    sha256 cellar: :any_skip_relocation, ventura:       "e735997feac41cf87e25cd38df9005fff6f6215829024de798391b92cae11764"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3f35d1b2e82f4bd842cdcd6e7d5f0687365761d23082c1c1ffddef38b132f8a"
  end

  depends_on "go" => :build

  def install
    mod = "github.com/eat-pray-ai/yutu/cmd"
    ldflags = %W[-w -s
                 -X #{mod}.Os=#{OS.mac? ? "darwin" : "linux"}
                 -X #{mod}.Arch=#{Hardware::CPU.arch}
                 -X #{mod}.Version=v#{version}
                 -X #{mod}.Commit=#{Utils.git_short_head(length: 7)}
                 -X #{mod}.CommitDate=#{time.iso8601}]
    system "go", "build", *std_go_args(ldflags:), "."
  end

  test do
    version_output = shell_output("#{bin}/yutu version 2>&1")
    assert_match "yutu🐰 version v#{version}", version_output
    auth_output = shell_output("#{bin}/yutu auth 2>&1", 1)
    assert_match "Please configure OAuth 2.0", auth_output
  end
end