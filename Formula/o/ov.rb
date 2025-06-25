class Ov < Formula
  desc "Feature-rich terminal-based text viewer"
  homepage "https:noborus.github.ioov"
  url "https:github.comnoborusovarchiverefstagsv0.42.0.tar.gz"
  sha256 "0532e0ca807dfcf6d77837117f90861051ab7cbecac9c6aa815294223cd1444c"
  license "MIT"
  head "https:github.comnoborusov.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06f375da38ba3f94a898811a6b9584e89a59b6cc222399f356b8d7696a9e5b0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06f375da38ba3f94a898811a6b9584e89a59b6cc222399f356b8d7696a9e5b0e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "06f375da38ba3f94a898811a6b9584e89a59b6cc222399f356b8d7696a9e5b0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "2be984361bb6917a66311c637a7f6feaa3af54f3e7c6eeeda7d7304f2a3d2427"
    sha256 cellar: :any_skip_relocation, ventura:       "2be984361bb6917a66311c637a7f6feaa3af54f3e7c6eeeda7d7304f2a3d2427"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "757acfd3954824cbf99e7c7588de37b248ac32b9dcdf9042a4c6c0c0f9253b26"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.Revision=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}ov --version")

    (testpath"test.txt").write("Hello, world!")
    assert_match "Hello, world!", shell_output("#{bin}ov test.txt")
  end
end