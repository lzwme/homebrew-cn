class Ggc < Formula
  desc "Modern Git CLI"
  homepage "https://github.com/bmf-san/ggc"
  url "https://ghfast.top/https://github.com/bmf-san/ggc/archive/refs/tags/v7.0.3.tar.gz"
  sha256 "ec6d86cfb273e56be3d93468f1441a3b367de2b07b9133ec08db8d7c7381c81c"
  license "MIT"
  head "https://github.com/bmf-san/ggc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c327fa04cca59947756938e38411efc322fc1cd600f9a0902c488fd0c7f161df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c327fa04cca59947756938e38411efc322fc1cd600f9a0902c488fd0c7f161df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c327fa04cca59947756938e38411efc322fc1cd600f9a0902c488fd0c7f161df"
    sha256 cellar: :any_skip_relocation, sonoma:        "f23b8982f11cbce68da6620f7d03bed2a4a353be732c95a66bc5137325cebc4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8f01c29e9198d16a40c8b107cc7e7f787c41e0383baad7d0a559e9691cb7aaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58bd1476c4479b65bfa31b5646f438dc2ce2f645e348e4bc5e6c38504b184033"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ggc version")

    # `vim` not found in `PATH`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_equal "main", shell_output("#{bin}/ggc config get default.branch").chomp
  end
end