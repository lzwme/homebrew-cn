class Sttr < Formula
  desc "CLI to perform various operations on string"
  homepage "https:github.comabhimanyu003sttr"
  url "https:github.comabhimanyu003sttrarchiverefstagsv0.2.24.tar.gz"
  sha256 "e9340c65c22d3016f9e4fe0a7f414bd1a8d8463203806c28b09a79889c805d76"
  license "MIT"
  head "https:github.comabhimanyu003sttr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa528ec2bd8efbc1126ceb0b6702e7cd8f90fb429f5690f02f39ff77d009a4a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa528ec2bd8efbc1126ceb0b6702e7cd8f90fb429f5690f02f39ff77d009a4a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fa528ec2bd8efbc1126ceb0b6702e7cd8f90fb429f5690f02f39ff77d009a4a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e18d094bbf79a426042de8d821efaddac406fa0a34ab1f536c9bf8e80b14ed0"
    sha256 cellar: :any_skip_relocation, ventura:       "3e18d094bbf79a426042de8d821efaddac406fa0a34ab1f536c9bf8e80b14ed0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ac912ccf592e11d84b1d2f655cbbc920672b6de974a5e611da733aa2017e317"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}sttr version")

    assert_equal "foobar", shell_output("#{bin}sttr reverse raboof")

    output = shell_output("#{bin}sttr sha1 foobar")
    assert_equal "8843d7f92416211de9ebb963ff4ce28125932878", output

    assert_equal "good_test", shell_output("#{bin}sttr snake 'good test'")
  end
end