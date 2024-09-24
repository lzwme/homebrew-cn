class GitSpice < Formula
  desc "Manage stacked Git branches"
  homepage "https:github.comabhinavgit-spice"
  url "https:github.comabhinavgit-spicearchiverefstagsv0.6.0.tar.gz"
  sha256 "34b5161ca642bb70269c45b9726137832eb95737465c6134995de5be2e1ef1d6"
  license all_of: [
    "GPL-3.0-or-later",
    "BSD-3-Clause", # internalkomplete{komplete.go, komplete_test.go}
  ]
  head "https:github.comabhinavgit-spice.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35dc3ca3f64796368719d9e3a8d5f3300a76c5c3895bf714119be542cc543b33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35dc3ca3f64796368719d9e3a8d5f3300a76c5c3895bf714119be542cc543b33"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "35dc3ca3f64796368719d9e3a8d5f3300a76c5c3895bf714119be542cc543b33"
    sha256 cellar: :any_skip_relocation, sonoma:        "440c9e3825ccd9c786bc50be608d2493702c262e973d6e4287eb087951e0dde0"
    sha256 cellar: :any_skip_relocation, ventura:       "440c9e3825ccd9c786bc50be608d2493702c262e973d6e4287eb087951e0dde0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f11a3fce1d8a9e8dacce5b64a8338af99e4754aac2447b006b64cdbaf2f4107c"
  end

  depends_on "go" => :build

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