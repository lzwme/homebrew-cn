class Tbls < Formula
  desc "CI-Friendly tool for document a database"
  homepage "https:github.comk1LoWtbls"
  url "https:github.comk1LoWtblsarchiverefstagsv1.75.0.tar.gz"
  sha256 "54ef5a6688af522f2bc88f9e2bfe7f45ab1595aa10e54036b140cb241bef313f"
  license "MIT"
  head "https:github.comk1LoWtbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dbf086580a278db26a07d58c52e2b3fb58c9654c093187b195925c028d16e0d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0ef9ee10c872c5c47f6cff466f4bcd33fc1f1f9038e72827575b941ddc547f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07a6a8f2dcab6378c938e33726f3d56d06ee443ed14cde669822aab64d484d50"
    sha256 cellar: :any_skip_relocation, sonoma:         "4f7c1cf110b926a378c35fa350b9f2fb13851540829542c806e129ded33fed60"
    sha256 cellar: :any_skip_relocation, ventura:        "72b146bcfa44b94b7a03dc1b995b8c2d2ab7b52e552308326a309fa423fe24e9"
    sha256 cellar: :any_skip_relocation, monterey:       "2b50ef6864427290409f46ddb883e6653d03c1621549910a5734d783b8d1fe53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02a9b2f29118da24def7bdd920dca05c0a653f5d2842bfaed181f05ad3038cf8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comk1LoWtbls.version=#{version}
      -X github.comk1LoWtbls.date=#{time.iso8601}
      -X github.comk1LoWtblsversion.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"tbls", "completion")
  end

  test do
    assert_match "invalid database scheme", shell_output(bin"tbls doc", 1)
    assert_match version.to_s, shell_output(bin"tbls version")
  end
end