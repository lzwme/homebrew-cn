class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https:infisical.comdocsclioverview"
  url "https:github.comInfisicalinfisicalarchiverefstagsinfisical-cliv0.35.0.tar.gz"
  sha256 "30eed6dff3a9f5d220d931d5264e84b26de8d8e6a8fe12527bd41bc2425cef19"
  license "MIT"
  head "https:github.comInfisicalinfisical.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^infisical-cliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "977b770273ea0f13257754158a5f9ec3ed31463d790c3de66571b2da2899c88c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "977b770273ea0f13257754158a5f9ec3ed31463d790c3de66571b2da2899c88c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "977b770273ea0f13257754158a5f9ec3ed31463d790c3de66571b2da2899c88c"
    sha256 cellar: :any_skip_relocation, sonoma:        "a42d716a699fd735462c58f3cd86efea37cfe3314facb1745a98a380865c584f"
    sha256 cellar: :any_skip_relocation, ventura:       "a42d716a699fd735462c58f3cd86efea37cfe3314facb1745a98a380865c584f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef0df286281a9ddd522b8f16e1fd7b70c53a31a3e2b27111b0b419b069221157"
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