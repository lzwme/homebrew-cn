class Logdy < Formula
  desc "Web based real-time log viewer"
  homepage "https:logdy.dev"
  url "https:github.comlogdyhqlogdy-corearchiverefstagsv0.13.tar.gz"
  sha256 "e23010f4979f79b6545181d35a27b4e80f08815f7f9bfb089eb3d1bd4879fa0d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a9190a20f9e29be0744ac4ecf864d4cfa6db9c04dfc8ee3b934e1f702cebbb61"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba142b96d4dd276dbfaa45ffc42e41ab2918b41b3312d7d7ed23c215c97ad61c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb2e139edd2ebb0d0e0939f3a93b6a19e86e21b84d63d2d9db05fc88c10c549f"
    sha256 cellar: :any_skip_relocation, sonoma:         "3cfecfbe4f13c85bc25453e83bac7ccb079d42bb9b87a5dedb7e518432ed56b3"
    sha256 cellar: :any_skip_relocation, ventura:        "bed24d829f1f6110106d3626f4f11d5ed7afd9b0c12a7c4bdd3a53e4d297fd05"
    sha256 cellar: :any_skip_relocation, monterey:       "0790f3c87c788b3c50b9aceb2590b4bb56d1d4cf3d6a0afb83dc12546e9bcb40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f239bd7a6a7ad620f541c1b06250e3cce3929746be8d76ec3e2c268b6eba8326"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X 'main.Version=#{version}'"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    r, _, pid = PTY.spawn("#{bin}logdy --port=#{free_port}")
    assert_match "Listen to stdin (from pipe)", r.readline
  ensure
    Process.kill("TERM", pid)
  end
end