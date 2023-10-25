class Gf < Formula
  desc "App development framework of Golang"
  homepage "https://goframe.org"
  url "https://ghproxy.com/https://github.com/gogf/gf/archive/refs/tags/v2.5.6.tar.gz"
  sha256 "a3b5c5abd29c134d6d586a39b3311c4763debb3bb1b25057ea377fc6ae1f6980"
  license "MIT"
  head "https://github.com/gogf/gf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "233492c7a3ae7f3577a72b68a1478f75f92adfc33bc1a7a2b91e81053a20ec3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e26716c6a0a95f0e2613e673595289723f1054268cc5f7d5e44815de8e314072"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "661ca93e7554c878e33908ae8435183c65cb580b9439d686760240642c6b589d"
    sha256 cellar: :any_skip_relocation, sonoma:         "e7b0106053f4b19f52769f198fd2e00998e989792f9ba92c738b22151e0a732d"
    sha256 cellar: :any_skip_relocation, ventura:        "10600a42198a9537c37753b460883c0117c077c15a781a787420026367671ade"
    sha256 cellar: :any_skip_relocation, monterey:       "498134bec398674ac590381d9cf478c2eb768bb36c4fa13e9cef4ec618bbf959"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f1b47650376a7d0476d09740139462a602af4836a79a5d718f76efdc43d4516"
  end

  depends_on "go" => [:build, :test]

  def install
    cd "cmd/gf" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    output = shell_output("#{bin}/gf --version 2>&1")
    assert_match "GoFrame CLI Tool v#{version}, https://goframe.org", output
    assert_match "GoFrame Version: cannot find go.mod", output

    output = shell_output("#{bin}/gf init test 2>&1")
    assert_match "you can now run \"cd test && gf run main.go\" to start your journey, enjoy!", output
  end
end