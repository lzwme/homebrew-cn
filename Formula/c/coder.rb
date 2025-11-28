class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://ghfast.top/https://github.com/coder/coder/archive/refs/tags/v2.27.7.tar.gz"
  sha256 "9765404a5089cbdef0f34ed50784d0556f1923b21b2e128002ce04fbdaef6f98"
  license "AGPL-3.0-only"
  head "https://github.com/coder/coder.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77c529a87a6950cf1fae107cdd62edf312efa95025211d97bfd2940c251200ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17f01d357084b63a087dbc52b3affc8be429d2addd63100a75b12ba6415b4ba7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "236ee04e43026b52714c0f7b762f3e5e51eb1a26fa786a23c1245a5b43131323"
    sha256 cellar: :any_skip_relocation, sonoma:        "4fd909e809cca8c536ff27c2ff62ccd31604031ea0f7eab629e94c5dcc9b4dbc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95288bbc3bc9eed7f975288e69b3d73efa192abfdd67066ec95eb53ba9b1cf93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0497d1d3e562e533ad78e3022a10eaa53678e997dfffbe13c178e3d2b2b2879"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/coder/coder/v2/buildinfo.tag=#{version}
      -X github.com/coder/coder/v2/buildinfo.agpl=true
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "slim"), "./cmd/coder"
  end

  test do
    version_output = shell_output("#{bin}/coder version")
    assert_match version.to_s, version_output
    assert_match "AGPL", version_output
    assert_match "Slim build", version_output

    assert_match "You are not logged in", shell_output("#{bin}/coder netcheck 2>&1", 1)
  end
end