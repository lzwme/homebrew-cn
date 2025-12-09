class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.39.tar.gz"
  sha256 "152d7e36f0461431352f66c5d2013290deb3281267e0d6c193dbebc8f350bb36"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71b9d421c6408af341ab5d3cb7eb4297832f62a5c287bc47211fc062e6b0cdef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71b9d421c6408af341ab5d3cb7eb4297832f62a5c287bc47211fc062e6b0cdef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71b9d421c6408af341ab5d3cb7eb4297832f62a5c287bc47211fc062e6b0cdef"
    sha256 cellar: :any_skip_relocation, sonoma:        "4791461362c25ce46725b28f229b6e212e049799f98ace84a7eb720fdbaa467d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be070d559cb629278919f80d5483c2d8b0ce3cf90fd41b08164c7289e446179f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "036707f3dd2b3c3f7ebf2d5ae3a2f7096efc1ec2b86be19612457fabbe549767"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/infisical --version")

    output = shell_output("#{bin}/infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}/infisical agent 2>&1")
    assert_match "starting Infisical agent", output
  end
end