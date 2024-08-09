class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https:helm.sh"
  url "https:github.comhelmhelm.git",
      tag:      "v3.15.3",
      revision: "3bb50bbbdd9c946ba9989fbe4fb4104766302a64"
  license "Apache-2.0"
  revision 1
  head "https:github.comhelmhelm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0462f1b6824f651808aa2354b7f89743c793b37419409782632a227e820761a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "509b4319b0cff80f29e538bbdcf998a4c9511f0030bbe1786639abd6e14c1cb2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4c613ac4af84b3550663dfbf3189e3098b582446a911cfafb0716816beacfa8"
    sha256 cellar: :any_skip_relocation, sonoma:         "c6d31019e0a7067743c92788ea6261fb8f01d4706d8d7f1cb89431bac521715e"
    sha256 cellar: :any_skip_relocation, ventura:        "71cfc3170dad466b34779b2feb27473f8c5b5979e429c50591e523b5c3c2627a"
    sha256 cellar: :any_skip_relocation, monterey:       "207632300ecc9d05f62df2f211c5ff9e0ff91f1a5e83c9f9f173203bd1e7319b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e81d4a5760eb11e4a52c67449728bb6da560f68b46d24e3b3cc3a7d1af4fd369"
  end

  depends_on "go" => :build

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
    assert_match "GitTreeState:\"clean\"", version_output
    assert_match "GitCommit:\"#{stable.specs[:revision]}\"", version_output
    assert_match "Version:\"v#{version}\"", version_output
  end
end