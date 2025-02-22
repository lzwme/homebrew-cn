class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https:infisical.comdocsclioverview"
  url "https:github.comInfisicalinfisicalarchiverefstagsinfisical-cliv0.34.2.tar.gz"
  sha256 "cc0ae13298d6766f061cf968d77a4c2d392517aa460f1d8798ec25fe27e99dd9"
  license "MIT"
  head "https:github.comInfisicalinfisical.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^infisical-cliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a67692400259c89ef72d66305ad2044f9507b978f095975a05c43145bbe07d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a67692400259c89ef72d66305ad2044f9507b978f095975a05c43145bbe07d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2a67692400259c89ef72d66305ad2044f9507b978f095975a05c43145bbe07d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab5abe9f7cd7916d21354f15850d6aa9ba9f21f8e204fc71f021cf2637125d42"
    sha256 cellar: :any_skip_relocation, ventura:       "ab5abe9f7cd7916d21354f15850d6aa9ba9f21f8e204fc71f021cf2637125d42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de44651ba00eece2b22d78900a5165c1cf86d87d1de48cac459980ea1b156123"
  end

  depends_on "go"

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

    output = shell_output("#{bin}infisical init 2>&1", 1)
    assert_match "You must be logged in to run this command.", output
  end
end