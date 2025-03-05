class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https:istio.io"
  url "https:github.comistioistioarchiverefstags1.25.0.tar.gz"
  sha256 "1aa988b6fd79915e09e32768854ae564f3479ad0caa16e60895d85815cf6ed4a"
  license "Apache-2.0"
  head "https:github.comistioistio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "320edb753ac63c45bafcd46df90c2d93c76974d64562c0fdd4cee8501289a9c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f52a9c1b88a27a475619c9bfef4bef8cabf2cfa955dd65c6f6fdb0cf87fb99f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6fcef81488f26bf6491936a745b0fad82ee67f5d87b22cfbf558934287b3b1af"
    sha256 cellar: :any_skip_relocation, sonoma:        "8059e8032dec14fe9d361cfb72fe621267641e7301899b6e6b3fa7aefa0c93ee"
    sha256 cellar: :any_skip_relocation, ventura:       "63f5ab9eaa2fa3637448366f375e8055cf0743a1c7b0acca0c4c9e4d34bf9599"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d5928d18cbe279c931e088982db842c60e20920f54dc0a3a132c750d957bf06"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X istio.ioistiopkgversion.buildVersion=#{version}
      -X istio.ioistiopkgversion.buildGitRevision=#{tap.user}
      -X istio.ioistiopkgversion.buildStatus=#{tap.user}
      -X istio.ioistiopkgversion.buildTag=#{version}
      -X istio.ioistiopkgversion.buildHub=docker.ioistio
    ]
    system "go", "build", *std_go_args(ldflags:), ".istioctlcmdistioctl"

    generate_completions_from_executable(bin"istioctl", "completion")
    system bin"istioctl", "collateral", "--man"
    man1.install Dir["*.1"]
  end

  test do
    assert_equal "client version: #{version}", shell_output("#{bin}istioctl version --remote=false").strip
  end
end