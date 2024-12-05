class Oauth2l < Formula
  desc "Simple CLI for interacting with Google oauth tokens"
  homepage "https:github.comgoogleoauth2l"
  url "https:github.comgoogleoauth2larchiverefstagsv1.3.2.tar.gz"
  sha256 "9de1aac07d58ad30cfeca4c358708cffa3fb38dfe98ce13abd984a4fd5e3b22a"
  license "Apache-2.0"
  head "https:github.comgoogleoauth2l.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e9ed0e17a3458be986a8f3122c9f1f066c5f7e25ce9b2f8617c80918dbb0d1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "adb753444a927dfa12ee327d666b53b77fece614f51e5d6e1ab9f6cf58504faf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "502272c9b97bf9e4b6e6f83b9c2873871a0eaeec538eb14cb756f8955445c957"
    sha256 cellar: :any_skip_relocation, sonoma:        "d36f1dae23535c0c18b98b3ef5528b78b32653d79eefe045e87e30b4291c32d4"
    sha256 cellar: :any_skip_relocation, ventura:       "90fa598787e32da22cb315d0defd7b8638889328cc216af039ef88528d766d07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a4d8fbeb4480c583ac54810b82ebfeb664c5166b3e575418c2078bb1105e38e"
  end

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "on"

    system "go", "build", "-o", "oauth2l"
    bin.install "oauth2l"
  end

  test do
    assert_match "Invalid Value",
      shell_output("#{bin}oauth2l info abcd1234")
  end
end