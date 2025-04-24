class Render < Formula
  desc "Command-line interface for Render"
  homepage "https:render.comdocscli"
  url "https:github.comrender-osscliarchiverefstagsv2.1.2.tar.gz"
  sha256 "87e4ce727116d186a965994b438b11ca6c360ae8c6c8c78327a4e8437f847527"
  license "Apache-2.0"
  head "https:github.comrender-osscli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "123ee25dae4982ef3b3920f2a9802e93c16ef3eda4169aa2c51b3808a158b155"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "123ee25dae4982ef3b3920f2a9802e93c16ef3eda4169aa2c51b3808a158b155"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "123ee25dae4982ef3b3920f2a9802e93c16ef3eda4169aa2c51b3808a158b155"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4b595343122b4ff6b022732e19ce0deb0e9d35820931e1a9746d5e63a86591b"
    sha256 cellar: :any_skip_relocation, ventura:       "a4b595343122b4ff6b022732e19ce0deb0e9d35820931e1a9746d5e63a86591b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c67c143a589a71512e932ddefebae728fd1d57700a274669a073d505381eb9e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comrender-ossclipkgcfg.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    error_msg = "Error: run `render login` to authenticate"
    assert_match error_msg, shell_output("#{bin}render services -o json 2>&1", 1)
  end
end