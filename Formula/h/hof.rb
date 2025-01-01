class Hof < Formula
  desc "Flexible data modeling & code generation system"
  homepage "https:hofstadter.io"
  url "https:github.comhofstadter-iohofarchiverefstagsv0.6.10.tar.gz"
  sha256 "87703d19a23121a4b617f1359aed9616dceb6c79718245861835b61ccff7e1eb"
  license "Apache-2.0"
  head "https:github.comhofstadter-iohof.git", branch: "_dev"

  # Latest release tag contains `-beta`, which is not ideal
  # adding a livecheck block to check the stable release
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f0e8e9411012fd34e7dee38bb284473b840303bd337d351d2fdb14d1f9a05d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2814977a66e59242903141f5a0dea62c3b41873890d132c35fc877a65894aac5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ff2fda5f13cb7bd4380b09af1bbd7801ab06c89aada6cfad0e54e70befd4a35f"
    sha256 cellar: :any_skip_relocation, sonoma:        "46c3e2e2c088c8d5e22b4fe0d866ed336da7f9d8d559b2467a90b57bcc69d49c"
    sha256 cellar: :any_skip_relocation, ventura:       "906dfda33113f5b1d5a0c77efcd6db259de850575048d7384dd8c08647880a3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "864e536e05475800bc1303a29f19c1f68a6f73ed05bfbd86112904449ddeb0e9"
  end

  # use "go" again after https:github.comhofstadter-iohofissues391 is fixed and released
  depends_on "go@1.22" => :build

  def install
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    os = OS.kernel_name.downcase

    ldflags = %W[
      -s -w
      -X github.comhofstadter-iohofcmdhofverinfo.Version=#{version}
      -X github.comhofstadter-iohofcmdhofverinfo.Commit=
      -X github.comhofstadter-iohofcmdhofverinfo.BuildDate=#{time.iso8601}
      -X github.comhofstadter-iohofcmdhofverinfo.GoVersion=#{Formula["go"].version}
      -X github.comhofstadter-iohofcmdhofverinfo.BuildOS=#{os}
      -X github.comhofstadter-iohofcmdhofverinfo.BuildArch=#{arch}
    ]

    ENV["HOF_TELEMETRY_DISABLED"] = "1"
    system "go", "build", *std_go_args(ldflags:), ".cmdhof"

    generate_completions_from_executable(bin"hof", "completion")
  end

  test do
    ENV["HOF_TELEMETRY_DISABLED"] = "1"

    assert_match version.to_s, shell_output("#{bin}hof version")

    system bin"hof", "mod", "init", "brew.shbrewtest"
    assert_predicate testpath"cue.mod", :exist?
    assert_match 'module: "brew.shbrewtest"', (testpath"cue.modmodule.cue").read
  end
end