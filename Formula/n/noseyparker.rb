class Noseyparker < Formula
  desc "Finds secrets and sensitive information in textual data and Git history"
  homepage "https:github.compraetorian-incnoseyparker"
  url "https:github.compraetorian-incnoseyparkerarchiverefstagsv0.18.0.tar.gz"
  sha256 "2178f66a776c88c46d0b1913be4901f59867db19a351201328fcad1abe5f1347"
  license "Apache-2.0"
  head "https:github.compraetorian-incnoseyparker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5bcfa60c2acdf214afa183bd36b9ba1c91f2e1c709f5cf611e2176992c66b4f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c1592bea708400da2d2d205ba882f5755535436c8835f780f9e83b4aef82212"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bcf219219776f2fc338eacaba4b6bfdbf2a987f684949b6bb6273ece61755508"
    sha256 cellar: :any_skip_relocation, sonoma:         "b32ed71f242af7f3f2f10f5a310d22564e37722b961b8ed137d136725a2401d7"
    sha256 cellar: :any_skip_relocation, ventura:        "268393716063f4e75b3b05960dadd8fd442927035bac75f8b1f7623c674226ab"
    sha256 cellar: :any_skip_relocation, monterey:       "b17616103dce74d3cbf0bbf1776469e13f4a59727d358edddc687752ff49e17a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab08da2b6c299e99fc5333ee50810c7e0b77424d278f81938560411f1598e7c2"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    ENV["VERGEN_GIT_BRANCH"] = "main"
    ENV["VERGEN_GIT_COMMIT_TIMESTAMP"] = time.iso8601
    ENV["VERGEN_GIT_SHA"] = tap.user
    system "cargo", "install", "--features", "release", *std_cargo_args(path: "cratesnoseyparker-cli")
    mv bin"noseyparker-cli", bin"noseyparker"

    generate_completions_from_executable(bin"noseyparker", "generate", "shell-completions", "--shell")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}noseyparker -V")

    output = shell_output(bin"noseyparker scan --git-url https:github.comHomebrewbrew")
    assert_match "00 new matches", output
  end
end