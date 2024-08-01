class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https:convox.com"
  url "https:github.comconvoxconvoxarchiverefstags3.18.8.tar.gz"
  sha256 "69b74bcbac2c5d6c26dd7ad1083981beaf1a677deee5ac7bf4dec2f1bdaea28d"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2318e328ac3dde684d0f38825be2744aab7d3739e093fe7e2a26e97bae07188e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b5b3a6673d0cbabf9515f68c419a7fa66640195957b363d2800bc42bbb6c406"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4449200a2125397dd6e2599400e370238c35182015212d759492808183b4b37b"
    sha256 cellar: :any_skip_relocation, sonoma:         "f0633a712c71b703e1d78a06816a4441b6d43d8e3da0185a377e436fbceebf05"
    sha256 cellar: :any_skip_relocation, ventura:        "0e20a9c4a1b4726a256a340552f3fa3ecab4169f32e53ceb714974866b9d69ed"
    sha256 cellar: :any_skip_relocation, monterey:       "5bdec86f8a6eaaeb0584ace9aeb4e57b8c41f6789e05ab16e069acb18ed7431e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f40c35ce8b4b714e77674d162dfc136a5a1c85d8fda13863e3b869879c7ccbe"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]

    system "go", "build", "-mod=readonly", *std_go_args(ldflags:), ".cmdconvox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}convox login -t invalid localhost 2>&1", 1)
  end
end