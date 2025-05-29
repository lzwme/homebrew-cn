class GitSpice < Formula
  desc "Manage stacked Git branches"
  homepage "https:abhinav.github.iogit-spice"
  url "https:github.comabhinavgit-spicearchiverefstagsv0.14.0.tar.gz"
  sha256 "0a22e815e2add7cc3a62a474e87778d344e4048d7eb3dfa0257a7c82552e6e56"
  license "GPL-3.0-or-later"
  head "https:github.comabhinavgit-spice.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d6f1b2ab2012dacaceb4b2206f9b8e8234f8259a7eced58cf498882b7a8501b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d6f1b2ab2012dacaceb4b2206f9b8e8234f8259a7eced58cf498882b7a8501b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0d6f1b2ab2012dacaceb4b2206f9b8e8234f8259a7eced58cf498882b7a8501b"
    sha256 cellar: :any_skip_relocation, sonoma:        "af8a20bde115b2fa8fe1272d3dc8d3c2fcdceb561b3e8cdf3c829cb760e6c8b7"
    sha256 cellar: :any_skip_relocation, ventura:       "af8a20bde115b2fa8fe1272d3dc8d3c2fcdceb561b3e8cdf3c829cb760e6c8b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "796ed4c3cc6d6fcf24101ca1a7960d5331eca8727f3d0183de869f0fe523af32"
  end

  depends_on "go" => :build

  conflicts_with "ghostscript", because: "both install `gs` binary"

  def install
    ldflags = "-s -w -X main._version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin"gs")

    generate_completions_from_executable(bin"gs", "shell", "completion")
  end

  test do
    system "git", "init", "--initial-branch=main"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    touch "foo"
    system "git", "add", "foo"
    system "git", "commit", "-m", "bar"

    assert_match "main", shell_output("#{bin}gs log long 2>&1")

    output = shell_output("#{bin}gs branch create feat1 2>&1", 1)
    assert_match "error: Terminal is dumb, but EDITOR unset", output

    assert_match version.to_s, shell_output("#{bin}gs --version")
  end
end