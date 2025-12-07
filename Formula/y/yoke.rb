class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.19.2",
      revision: "32a9e67cb87d5b2a9a14ef73729e2768cef22b9e"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "08fc580f5b156de8020dcf4fb54271cae8d58f0babdbd44e262989a0c1708989"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b395ebd3975b9a867bd542f8392f95e1dee629f2cd712542fe3f8c16e01f9a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b205f188e8388cf8ce014147f53e3bde4de7c674c062eebf3fa9c78d4edbed5"
    sha256 cellar: :any_skip_relocation, sonoma:        "6cee598e550376839ad753653c29f47c31edcec8c26b9b344cfe6c3f55b9778a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d33a996a63ccd7a8023065a52d3a1b69ec064e524c71ed856781aec6c46d9916"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "defd90c7b2386cf9d41eae3a6789ce570ed7f50f962cffd89dbe5ef6531971aa"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/yoke"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yoke version")

    assert_match "failed to build k8 config", shell_output("#{bin}/yoke inspect 2>&1", 1)
  end
end