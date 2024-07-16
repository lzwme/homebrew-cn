class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https:budimanjojo.github.iotalhelperlatest"
  url "https:github.combudimanjojotalhelperarchiverefstagsv3.0.4.tar.gz"
  sha256 "eb5a6837d8ef47ecac7ba370b39d15a92af2b75cae2c1afa612dadc81be02d46"
  license "BSD-3-Clause"
  head "https:github.combudimanjojotalhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f538d63a3cf51e5b8d24cd0d1ceac9a163a74ecff18d4b5f1f8df940cb5ad0ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0eac7be29a3c4cc82b0365dac8300e8cfff869bd70374a74433683e2afc5bc0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff7a7ba88617a23ee694b6cd65f2a395a3dff2ffd432e6f37c6fab354c05c3a2"
    sha256 cellar: :any_skip_relocation, sonoma:         "afede40c353f4d1cb9dc55e70a0282bf3950ac1fe6be77b9ef1fc2e0db35c0f4"
    sha256 cellar: :any_skip_relocation, ventura:        "055930fed85bccb8c1419090807e2398dd6cf2492cd7b64b94568445aa57f4d1"
    sha256 cellar: :any_skip_relocation, monterey:       "a5367addd067f3ca8e77d2a2fde18b4c3b8ec5cfd94226429efcdcd9398b4946"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a99fede3794dd6d4256988d760f1fd3487a9b43b93f458a06360c755a9354d32"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.combudimanjojotalhelperv#{version.major}cmd.version=#{version}"
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