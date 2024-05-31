class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https:budimanjojo.github.iotalhelperlatest"
  url "https:github.combudimanjojotalhelperarchiverefstagsv2.4.9.tar.gz"
  sha256 "5d0a03fd4709fbe0dfd7aef6211b849dcbf8da0a3539962b67ca6b2d9b7382cc"
  license "BSD-3-Clause"
  head "https:github.combudimanjojotalhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "85c66521388eb8868fa9da42c284c5f0c3278badbcf109fd63caabf3a56527f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd6e2be4ced358fb66bb86c10852005f2beb0239b00790ecf688d73f7a6fc729"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "093ee6a7a004e941424ad1d821e2298144ec3c64b98730f5164188e8f0d2a199"
    sha256 cellar: :any_skip_relocation, sonoma:         "3abc52ca0f3ad0edf5f592deef1883a81e33bd37a2e7d47b483794d0aca194c5"
    sha256 cellar: :any_skip_relocation, ventura:        "539f27fe281a34b8a808fcd0296cbf0f157dc2d688c304594fd633b5f355029f"
    sha256 cellar: :any_skip_relocation, monterey:       "b6a8598e39cee2c09f8a4a7da0a8424b9d157f883b545a7b1d67acc921408c17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5fb695178ca10d2610ec2bb29734a3ab9d5c406e84f29bfc79e28e2dd31bfc4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.combudimanjojotalhelpercmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"talhelper", "completion")
    pkgshare.install "example"
  end

  test do
    cp_r Dir["#{pkgshare}example*"], testpath

    output = shell_output("#{bin}talhelper genconfig 2>&1", 1)
    assert_match "failed to load env file: trying to decrypt talenv.yaml with sops", output

    assert_match "cluster:", shell_output("#{bin}talhelper gensecret")

    assert_match version.to_s, shell_output("#{bin}talhelper --version")
  end
end