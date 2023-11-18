class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://ghproxy.com/https://github.com/coder/coder/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "11735658fc52225e061b32a655739446e7cff57e511de46d5030cac496f6f4b5"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "411180f8e6335b984c91199f94b8ebd5c5ec9657123d6468adb8b0eb06695937"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9a39392afd413135863b96e7435fd774d1514346a448cc7a480b420e195dc472"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9cfb775baecad5cf3c992d9c6993c0614ec866de3596f83b4fb78741ec9d1b15"
    sha256 cellar: :any_skip_relocation, sonoma:         "23bb62247f785a8aa8d99eda87fc6127cdbc4f1f2ee2868d89115b3a7f6234d1"
    sha256 cellar: :any_skip_relocation, ventura:        "05f91f518060a4de6d844b2fa482083476513e387859744ad319671e07cd80fd"
    sha256 cellar: :any_skip_relocation, monterey:       "3eb951acb9de091f4b5678d1e3bc3dee3aca196fa282e8153cd43678e7589028"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "713b18fc0df29bc69016fc37a0f9661aa36d6d0a8d9af43c8edf8ebb9a21c774"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/coder/coder/v2/buildinfo.tag=#{version}
      -X github.com/coder/coder/v2/buildinfo.agpl=true
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "slim", "./cmd/coder"
  end

  test do
    version_output = shell_output("#{bin}/coder version")
    assert_match version.to_s, version_output
    assert_match "AGPL", version_output
    assert_match "Slim build", version_output

    assert_match "You are not logged in", shell_output("#{bin}/coder netcheck 2>&1", 1)
  end
end