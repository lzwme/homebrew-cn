class Dagger < Formula
  desc "Portable devkit for CICD pipelines"
  homepage "https:dagger.io"
  url "https:github.comdaggerdagger.git",
      tag:      "v0.11.9",
      revision: "18fd28cfa8f2e5d5f2ccc58fb15a4a975a3660dd"
  license "Apache-2.0"
  head "https:github.comdaggerdagger.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0442d26c18bc0bab3f4d087b9495718c534858dcdaee89bd914128dd4b39244a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "85608197ffee0bf796a28c871129e1a7e859146ecde3de625f3aa041662a2c8e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "366d363c87e2554371bdd71b097cd14aa85d6056ed662141bb905abbc4012cd9"
    sha256 cellar: :any_skip_relocation, sonoma:         "eb3d862c31774afe649feabd20b612644e3c178a26bfa016d71ecad2d3e5f83d"
    sha256 cellar: :any_skip_relocation, ventura:        "8ff3385774ed7f90ef6718a5d02ac6bf41fdbe90bbff843e5f1be2223b64b4f4"
    sha256 cellar: :any_skip_relocation, monterey:       "4b188c64e2b1e55951db50a9723e07da25c5bcd42be0a38d3f9c43685923419e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "478aaa611d295b4edb5a8d25ae21e1977370f794a0d8a095fe475109972892c2"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.comdaggerdaggerengine.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmddagger"

    generate_completions_from_executable(bin"dagger", "completion")
  end

  test do
    ENV["DOCKER_HOST"] = "unix:#{testpath}invalid.sock"

    assert_match "dagger v#{version}", shell_output("#{bin}dagger version")

    output = shell_output("#{bin}dagger query brewtest 2>&1", 1)
    assert_match "Cannot connect to the Docker daemon", output
  end
end