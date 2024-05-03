class Tbls < Formula
  desc "CI-Friendly tool for document a database"
  homepage "https:github.comk1LoWtbls"
  url "https:github.comk1LoWtblsarchiverefstagsv1.74.2.tar.gz"
  sha256 "3a86b57b6203857c5dcfa94defb7006ef9dd7bec2494e0c51985ba482f0a3200"
  license "MIT"
  head "https:github.comk1LoWtbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d536a9b2a8c2c333de013bd36d12968cac6240ac251e79109d85cbf11bc7d1bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "603b12ca647fe4a5570c1a7149b6e01762676901122fd589a361db746efbb6ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "020cd90d59bdc52017026c7f3417917a68b8ee7688087ac8acd86e184f339690"
    sha256 cellar: :any_skip_relocation, sonoma:         "95da4feb10c48b67b19b9fd15637b766123b1e0c774475ad6abe141fadb37c6f"
    sha256 cellar: :any_skip_relocation, ventura:        "42d0a606b737e1e335b5c4412b9504a5e1b4e1447f6a160ecf399e29aef6d789"
    sha256 cellar: :any_skip_relocation, monterey:       "5fae2631ad992abf7e68638ff5082a40d25bc96b1530b123484d910bd28d17bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28202b3a2cbf1d4d0ff76f377cf70486da294ff9e1783f25947b02f40563b323"
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