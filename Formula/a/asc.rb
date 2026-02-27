class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rudrankriyam/App-Store-Connect-CLI/archive/refs/tags/0.35.1.tar.gz"
  sha256 "f4b651edb35ee93e088af2a15578a1802436fe9736188bc3525cd809ceb2bf66"
  license "MIT"
  head "https://github.com/rudrankriyam/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f7c66aa2628ad2c1d0b029ec7f390d10618f48fb178218413cb7ad8f6b65860"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fab6dca4a1aa974b8cfa17f710f63efc8d1bfb9188899285bc99f8c886356b80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5ca6dda3e76d0201266a8121ed8cdffc4aea15ef568ab4f96763e2b7c452530"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3b6cffd26ae252bf8e4c064c8a3cd18a742d3a8597c3df02a07550c8009e889"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c0243c1e1cf4a1949fbffd53687c961396580b75d5419298e7a4cd67147b15e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65b1cce9d07fe02c05176eb030159faa7facb6974367255d67bea307b7473406"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end