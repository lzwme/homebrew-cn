class Cloudfox < Formula
  desc "Automating situational awareness for cloud penetration tests"
  homepage "https:github.comBishopFoxcloudfox"
  url "https:github.comBishopFoxcloudfoxarchiverefstagsv1.12.3.tar.gz"
  sha256 "e082972b5368c90308ea97bc06a8732b0fc45053a78472022626392580fbe0b1"
  license "MIT"
  head "https:github.comBishopFoxcloudfox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "59c92823e841dcbaf48b46a74db99c2015fd6dd33cf52b4ee5330dfac93038e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "306c56cbdb4522afe0126af13589f8b128f086eb2d4ef93a3dbd57297eb3d8ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "818a10cafb3425c88594293d8771f7e8d1f3d347989a6378e0d49372c6ef5b78"
    sha256 cellar: :any_skip_relocation, sonoma:         "a4416f0530a052926a558e8d4802389bc505796775123854f9b67f22a21b01c3"
    sha256 cellar: :any_skip_relocation, ventura:        "5622de88b27f639d9963042cf93254ddaa408c73ec37c722739853d4f4374cf9"
    sha256 cellar: :any_skip_relocation, monterey:       "8ba124bd7ad77330a83c6e4da24860b8b40a93ac16cb8961dcf50fa92a78eaf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "451428735ae8d760f99b992b52635132f0574c94552b55fa374462e2650305e3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin"cloudfox", "completion")
  end

  test do
    ENV["AWS_ACCESS_KEY_ID"] = "test"
    ENV["AWS_SECRET_ACCESS_KEY"] = "test"

    output = shell_output("#{bin}cloudfox aws principals 2>&1")
    assert_match "Could not get caller's identity", output

    assert_match version.to_s, shell_output("#{bin}cloudfox --version")
  end
end