class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https:infisical.comdocsclioverview"
  url "https:github.comInfisicalinfisicalarchiverefstagsinfisical-cliv0.41.82.tar.gz"
  sha256 "ff53a31339fdb01044a31b0abb62649935c40762c4ac07cbc5807900b2bf8811"
  license "MIT"
  head "https:github.comInfisicalinfisical.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^infisical-cliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9451a5db2b868bb4b4c140a5ab8daebd419f2253353942642f27a9da447514bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9451a5db2b868bb4b4c140a5ab8daebd419f2253353942642f27a9da447514bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9451a5db2b868bb4b4c140a5ab8daebd419f2253353942642f27a9da447514bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a18fa3ff6304f76223b3e9b94d7fd7d376aeef53cefac93ef6407fbe6f8078b"
    sha256 cellar: :any_skip_relocation, ventura:       "1a18fa3ff6304f76223b3e9b94d7fd7d376aeef53cefac93ef6407fbe6f8078b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6ce26ae13edcd0c8e3fb3047af3e99aeac5cd6879a0c8e6b1ebc5dfdf8de4bd"
  end

  depends_on "go" => :build

  def install
    cd "cli" do
      ldflags = %W[
        -s -w
        -X github.comInfisicalinfisical-mergepackagesutil.CLI_VERSION=#{version}
      ]
      system "go", "build", *std_go_args(ldflags:)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}infisical --version")

    output = shell_output("#{bin}infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}infisical agent 2>&1")
    assert_match "starting Infisical agent", output
  end
end