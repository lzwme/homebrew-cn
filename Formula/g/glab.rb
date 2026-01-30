class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.82.0",
    revision: "b932a8d879a24d02e0c094aa178c7442c9a589a5"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5661ff30b68bed095127875b0e1e37682d1b98387ac6a38470bd9693bb5ce9ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5661ff30b68bed095127875b0e1e37682d1b98387ac6a38470bd9693bb5ce9ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5661ff30b68bed095127875b0e1e37682d1b98387ac6a38470bd9693bb5ce9ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "73af63952d134bf212d44b5da1990f4c1d60a7374b423f1d8fdff83d0dabdb4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d724596f3205d10fae41159bfe907cce3bc6b09748d72b058e240b9d1da077b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a94eff6404775a4ef6c96123a22c61f952dbb86bd5f18fd474e884c9ce378b07"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.mac?
    system "make"
    bin.install "bin/glab"
    generate_completions_from_executable(bin/"glab", "completion", "--shell")
  end

  test do
    system "git", "clone", "https://gitlab.com/cli-automated-testing/homebrew-testing.git"
    cd "homebrew-testing" do
      assert_match "Matt Nohr", shell_output("#{bin}/glab repo contributors")
      assert_match "This is a test issue", shell_output("#{bin}/glab issue list --all")
    end
  end
end