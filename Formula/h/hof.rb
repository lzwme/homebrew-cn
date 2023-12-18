class Hof < Formula
  desc "Flexible data modeling & code generation system"
  homepage "https:hofstadter.io"
  url "https:github.comhofstadter-iohof.git",
      tag:      "v0.6.8",
      revision: "112659fe982a3efbe0acdb151c659e0b8b2e081f"
  license "Apache-2.0"
  head "https:github.comhofstadter-iohof.git", branch: "_dev"

  # Latest release tag contains `-beta`, which is not ideal
  # adding a livecheck block to check the stable release
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5ce1d130e57ca005371ed0d8e49aef63c61e43ace3edc06392759e80458c25d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2ec0beb3aeb76431ec6291dc649f6e306498979957bd1e26cc69aff4a43ec99"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2ec0beb3aeb76431ec6291dc649f6e306498979957bd1e26cc69aff4a43ec99"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a2ec0beb3aeb76431ec6291dc649f6e306498979957bd1e26cc69aff4a43ec99"
    sha256 cellar: :any_skip_relocation, sonoma:         "63836892a87f36379eebcdd781efe1f975a8db57fe60889175a4f9aa9d81ae69"
    sha256 cellar: :any_skip_relocation, ventura:        "15a46e02722ff5b6da468434960d2b7f102502ff28a00a9e787d8029ab294731"
    sha256 cellar: :any_skip_relocation, monterey:       "15a46e02722ff5b6da468434960d2b7f102502ff28a00a9e787d8029ab294731"
    sha256 cellar: :any_skip_relocation, big_sur:        "15a46e02722ff5b6da468434960d2b7f102502ff28a00a9e787d8029ab294731"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3774eb841173eb8615417658f1c0c1588ad2ca86ce8ffa3766337890b1ec8214"
  end

  depends_on "go" => :build

  def install
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    os = OS.kernel_name.downcase

    ldflags = %W[
      -s -w
      -X github.comhofstadter-iohofcmdhofverinfo.Version=#{version}
      -X github.comhofstadter-iohofcmdhofverinfo.Commit=#{Utils.git_head}
      -X github.comhofstadter-iohofcmdhofverinfo.BuildDate=#{time.iso8601}
      -X github.comhofstadter-iohofcmdhofverinfo.GoVersion=#{Formula["go"].version}
      -X github.comhofstadter-iohofcmdhofverinfo.BuildOS=#{os}
      -X github.comhofstadter-iohofcmdhofverinfo.BuildArch=#{arch}
    ]

    ENV["CGO_ENABLED"] = "0"
    ENV["HOF_TELEMETRY_DISABLED"] = "1"
    system "go", "build", *std_go_args(ldflags: ldflags), ".cmdhof"

    generate_completions_from_executable(bin"hof", "completion")
  end

  test do
    ENV["HOF_TELEMETRY_DISABLED"] = "1"
    # upstream bug report, https:github.comhofstadter-iohofissues257
    # assert_match "v#{version}", shell_output("#{bin}hof version")

    system bin"hof", "mod", "init", "brew.shbrewtest"
    assert_predicate testpath"cue.mod", :exist?
    assert_match 'module: "brew.shbrewtest"', (testpath"cue.modmodule.cue").read
  end
end