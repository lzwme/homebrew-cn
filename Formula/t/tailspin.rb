class Tailspin < Formula
  desc "Log file highlighter"
  homepage "https:github.combensadehtailspin"
  url "https:github.combensadehtailspinarchiverefstags2.4.0.tar.gz"
  sha256 "ce86f2fd96543c62446f016ce332cd381d63d89c7094263459093ef2133a70a3"
  license "MIT"
  head "https:github.combensadehtailspin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0e88e8d8f3dd14f433684a191b34177aded5e5d865b8a4b0622df48f7ab39ceb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a4314dffcaed75c8c13e0a1472d078f338086f71c8d519a3d799897a4f727fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d013520f4678ac8b91bc08e0f819db65a20729fc0786c4d2095e94a5666ac3d4"
    sha256 cellar: :any_skip_relocation, sonoma:         "152f8d5f3806d496b26d00f02cdf70c8646b7c3860971529040d6e5b55770f24"
    sha256 cellar: :any_skip_relocation, ventura:        "453241c915fa815ae0bac8adff7c07e492e0cefc40dd0ecba2164a6adf914aef"
    sha256 cellar: :any_skip_relocation, monterey:       "cf5f698b44426b69a0891dc6594e33f8b240a773052a5007a3f24ad0b5a8b64e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8c32028c9f118169fd99d488568ed1d199b70083857bc28bd0f56e607e3b198"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"tspin", "--z-generate-shell-completions")
    man1.install "mantspin.1"
  end

  test do
    output = shell_output("#{bin}tspin --start-at-end 2>&1")

    expected = if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      ""
    else
      "Missing filename"
    end
    assert_match expected, output

    assert_match version.to_s, shell_output("#{bin}tspin --version")
  end
end