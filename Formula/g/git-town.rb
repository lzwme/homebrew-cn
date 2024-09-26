class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https:www.git-town.com"
  url "https:github.comgit-towngit-townarchiverefstagsv16.3.0.tar.gz"
  sha256 "1d71998a4772d8f8fa277fb31ddb74612b8c4586c62b4bd261c478f05dcedcc6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb8ecd981c88adbb7cf7b88149aa94d0a6adf203dfd76978ecdb4584417830f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb8ecd981c88adbb7cf7b88149aa94d0a6adf203dfd76978ecdb4584417830f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fb8ecd981c88adbb7cf7b88149aa94d0a6adf203dfd76978ecdb4584417830f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c96845a1c28bf0d741e8af534549adfeb79276569a551aed41c9335bdde5896"
    sha256 cellar: :any_skip_relocation, ventura:       "9c96845a1c28bf0d741e8af534549adfeb79276569a551aed41c9335bdde5896"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ae7c749b5c5694e5ae86a70a538912aefbcc4f11bbeacf1fa1f7b1b20e4f866"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comgit-towngit-townv#{version.major}srccmd.version=v#{version}
      -X github.comgit-towngit-townv#{version.major}srccmd.buildDate=#{time.strftime("%Y%m%d")}
    ]
    system "go", "build", *std_go_args(ldflags:)

    # Install shell completions
    generate_completions_from_executable(bin"git-town", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}git-town -V")

    system "git", "init"
    touch "testing.txt"
    system "git", "add", "testing.txt"
    system "git", "commit", "-m", "Testing!"

    system bin"git-town", "config"
  end
end