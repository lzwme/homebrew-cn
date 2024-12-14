class Frizbee < Formula
  desc "Throw a tag at and it comes back with a checksum"
  homepage "https:github.comstacklokfrizbee"
  license "Apache-2.0"
  revision 1
  head "https:github.comstacklokfrizbee.git", branch: "main"

  stable do
    url "https:github.comstacklokfrizbeearchiverefstagsv0.1.4.tar.gz"
    sha256 "73f6d7e9e9b507425b8c58101e6eab933aad27372cc531ffd110e283a6ff2d3e"

    # build patch to resolve commit correctly, remove in next release
    patch do
      url "https:github.comstacklokfrizbeecommitfbef552fec0c53133cec4a1ee2acc513599aa9d9.patch?full_index=1"
      sha256 "285c1a41b25ecf7ffd818006a151f97a2b93104ecee9d64bb70cd2635d4f031a"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93f8f8aec9503ec9c4036b98ae3c7d356cabee8f2ceca7e761e66b8ef8a8f6d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93f8f8aec9503ec9c4036b98ae3c7d356cabee8f2ceca7e761e66b8ef8a8f6d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "93f8f8aec9503ec9c4036b98ae3c7d356cabee8f2ceca7e761e66b8ef8a8f6d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b1dbf210e7de8bc465f9c17444e69b2b56d5fb3951380bdf5a6581fdb8c298d"
    sha256 cellar: :any_skip_relocation, ventura:       "8b1dbf210e7de8bc465f9c17444e69b2b56d5fb3951380bdf5a6581fdb8c298d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c4a6195d5c89e7a65119251e52459c2ef93184e2b6ff60145c1544bcb520456"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comstacklokfrizbeeinternalcli.CLIVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"frizbee", "completion")
  end

  test do
    assert_match version.to_s, shell_output(bin"frizbee version 2>&1")

    output = shell_output(bin"frizbee actions $(brew --repository).githubworkflowstests.yml 2>&1")
    assert_match "Processed: tests.yml", output
  end
end