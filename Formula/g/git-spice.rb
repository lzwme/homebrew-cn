class GitSpice < Formula
  desc "Manage stacked Git branches"
  homepage "https:github.comabhinavgit-spice"
  url "https:github.comabhinavgit-spicearchiverefstagsv0.7.1.tar.gz"
  sha256 "d5d3fd6979d2b636d61ca200dfc2e04d8a9e5a22666b7799760fc48c98484aa4"
  license all_of: [
    "GPL-3.0-or-later",
    "BSD-3-Clause", # internalkomplete{komplete.go, komplete_test.go}
  ]
  head "https:github.comabhinavgit-spice.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7c392c57d552e5ad0b1cfecc924d2bd13a7e8d4723f43c56dfe0dbc7bc7ebf2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7c392c57d552e5ad0b1cfecc924d2bd13a7e8d4723f43c56dfe0dbc7bc7ebf2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e7c392c57d552e5ad0b1cfecc924d2bd13a7e8d4723f43c56dfe0dbc7bc7ebf2"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe99c6d016f0f4423b74e824e82d4c79d922a124279e9d56e001393f43ae2669"
    sha256 cellar: :any_skip_relocation, ventura:       "fe99c6d016f0f4423b74e824e82d4c79d922a124279e9d56e001393f43ae2669"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34cc95a827755d8b01ffe61108367c47848e2188abc6349c1255fc0c7217088b"
  end

  depends_on "go" => :build

  conflicts_with "ghostscript", because: "both install `gs` binary"

  def install
    ldflags = "-s -w -X main._version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin"gs")

    generate_completions_from_executable(bin"gs", "shell", "completion", base_name: "gs")
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