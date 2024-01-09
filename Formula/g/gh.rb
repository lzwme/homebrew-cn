class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https:cli.github.com"
  url "https:github.comclicliarchiverefstagsv2.41.0.tar.gz"
  sha256 "bab15c4119f29e763355dd9a63b4e5824432b45834e5269353f3def6a27ccf80"
  license "MIT"

  head "https:github.comclicli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9ef53b4c36e3f096fe2fc8594b6aad1399fbf7b196ce556b01d72dc86a439f2f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a305ff4e22a94e417399232a61d1caf0adce27005c7faa76351a74df4ddf8b08"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67edf858087321bece68bd4b9b4227cf2e5dc0d5bfed3d87374deb93a05e6119"
    sha256 cellar: :any_skip_relocation, sonoma:         "f9513de06035fc6a9170df7bf371ab1ff0a2540d5eddb00128793cc803df3d6b"
    sha256 cellar: :any_skip_relocation, ventura:        "f3c4f5ffe4f5862d44e38a59c11450c8ed667b4683f99d5aefcd934d0a75350d"
    sha256 cellar: :any_skip_relocation, monterey:       "40253d2027f9c3ad59b869d9ce0d81e213ea09f81ed4a214a2199f1d66deb896"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a14849ffb58613e0d8f16f0e23545bda3a439e5134e392ca0b76ce856f5746f1"
  end

  depends_on "go" => :build

  def install
    with_env(
      "GH_VERSION" => version.to_s,
      "GO_LDFLAGS" => "-s -w -X main.updaterEnabled=clicli",
    ) do
      system "make", "bingh", "manpages"
    end
    bin.install "bingh"
    man1.install Dir["sharemanman1gh*.1"]
    generate_completions_from_executable(bin"gh", "completion", "-s")
  end

  test do
    assert_match "gh version #{version}", shell_output("#{bin}gh --version")
    assert_match "Work with GitHub issues", shell_output("#{bin}gh issue 2>&1")
    assert_match "Work with GitHub pull requests", shell_output("#{bin}gh pr 2>&1")
  end
end