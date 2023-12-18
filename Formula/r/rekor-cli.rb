class RekorCli < Formula
  desc "CLI for interacting with Rekor"
  homepage "https:docs.sigstore.devloggingoverview"
  url "https:github.comsigstorerekorarchiverefstagsv1.3.4.tar.gz"
  sha256 "08e220b6fbc473ecd3561e88c4fde2ca259f9daa895a17bed1f458c33c33a2b9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e8e26b614bd6b605583d37db40c0bb3dbddfd7ea6e725def7707060e36bda87b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc9eb88576c282cf247282d44695b097560e7d3b27c2d3a38b20b152bf2f52fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff8766ff2a64b3fa5bba04d46095f67e979f79a3380bf0fff25a0fa348c8e66d"
    sha256 cellar: :any_skip_relocation, sonoma:         "a57b83a3915f9a5426da8097d71a05071d84e6ebbfb6bf633e94e4eee4857952"
    sha256 cellar: :any_skip_relocation, ventura:        "66b5187e35658f527e08cc31216c40b3274fde718fe61b1567f05b3fa8cbb011"
    sha256 cellar: :any_skip_relocation, monterey:       "0d2643ccb1004498cd686728608ba6f901ac147f41c345a60bb25cff426ec208"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c10a4d35c226ad3d905235bfa08322ab2d69bc207fafd1d37f2a57ac544bbfe4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.iorelease-utilsversion.gitVersion=#{version}
      -X sigs.k8s.iorelease-utilsversion.gitCommit=#{tap.user}
      -X sigs.k8s.iorelease-utilsversion.gitTreeState=#{tap.user}
      -X sigs.k8s.iorelease-utilsversion.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), ".cmdrekor-cli"

    generate_completions_from_executable(bin"rekor-cli", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}rekor-cli version")

    url = "https:github.comsigstorerekorreleasesdownloadv#{version}rekor-cli-darwin-arm64"
    output = shell_output("#{bin}rekor-cli search --artifact #{url} 2>&1")
    assert_match "Found matching entries (listed by UUID):", output
  end
end