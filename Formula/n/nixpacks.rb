class Nixpacks < Formula
  desc "App source + Nix packages + Docker = Image"
  homepage "https://nixpacks.com/"
  url "https://ghproxy.com/https://github.com/railwayapp/nixpacks/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "f69ef217a91855c0c6bd250f0605a2434b78c29fb70315d3cd477c0f3ed47d95"
  license "MIT"
  head "https://github.com/railwayapp/nixpacks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "77e7da5136f38f39a5d7a708f5fb0a9a69382d421b6249d7cc7b1f671d5e7e60"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e85471fe7e173dffee04f221468d9f90d4573cf3dac16038c514f8ef0c23a8e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dbc32e95746af71e4284295f784f6013110181fda83eea8465e2b30eba265726"
    sha256 cellar: :any_skip_relocation, sonoma:         "8550b70711a1fae7c8a2cb71b72e86dca265d27bc17bef880f3cfbd1d86c2eb4"
    sha256 cellar: :any_skip_relocation, ventura:        "0ef627eebcf0d6cde8f59c96fb1452b16e2580e47a57c34b5cda0798075b421d"
    sha256 cellar: :any_skip_relocation, monterey:       "90912278d5bb48aa29bb6da4b77561d5ddbe61dafb9162771f8cfc8f17edb703"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd87a407f34549193befb30d419fe64b9240b5e847422f301eca382486a08486"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/nixpacks build #{testpath} --name test", 1)
    assert_match "Nixpacks was unable to generate a build plan for this app", output

    assert_equal "nixpacks #{version}", shell_output("#{bin}/nixpacks -V").chomp
  end
end