class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https:helm.sh"
  url "https:github.comhelmhelm.git",
      tag:      "v3.16.3",
      revision: "cfd07493f46efc9debd9cc1b02a0961186df7fdf"
  license "Apache-2.0"
  head "https:github.comhelmhelm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c41036a65f0eb30059a23392f183f30d9b911a235b3fd2f9f6f705933ce582f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b91608810e5b6a549a48f4cb1752600fc0ed5ccd7baf135a0bcae9c0cbcedb2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7708f6f58b68334b66c0dde364247886ab89ac039d93ec2b7d96517feb780381"
    sha256 cellar: :any_skip_relocation, sonoma:        "fdee88d23a69cbd9e24516fba463ab8db28e0e06b51a2324147261d2895f6daa"
    sha256 cellar: :any_skip_relocation, ventura:       "ce5a0236475e0539e9b05a4d89f6745ae8ace37aff3ce2271800415040660d6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc6109b8f168407ca3c6998a299a1437ce2bc657801b95d4ad1c2e8c9918aa98"
  end

  depends_on "go" => :build

  # fix testchart lint errors, upstream pr ref, https:github.comhelmhelmpull13329
  patch do
    url "https:github.comhelmhelmcommitddead08eb8e7e3fbbdbb6d40938dda36905789af.patch?full_index=1"
    sha256 "471c2d7dcbd48d37eaf69e552d53e928e9ba42efccb021d78bbd354599d80811"
  end

  def install
    system "make", "build"
    bin.install "binhelm"

    mkdir "man1" do
      system bin"helm", "docs", "--type", "man"
      man1.install Dir["*"]
    end

    generate_completions_from_executable(bin"helm", "completion")
  end

  test do
    system bin"helm", "create", "foo"
    assert File.directory? testpath"foocharts"

    version_output = shell_output("#{bin}helm version 2>&1")
    assert_match "GitCommit:\"#{stable.specs[:revision]}\"", version_output
    assert_match "Version:\"v#{version}\"", version_output
  end
end