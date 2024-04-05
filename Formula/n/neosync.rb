class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.4.tar.gz"
  sha256 "492ba1eba3ec9aaef11465c967fe604318b43406a09b1eb7a7600af52c1e6837"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d2ff5b0847102e69d59248b0b9a72df0503bf04b5e01b6bc31b14c8ae8452c1c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f41b126871ca28a78d72bfa33698be34b75605ebf9823f0a12bf54b764fc3dd4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8169145b5f4379d285d73a5dffb26838e9f43e6daa491d6c6a568a71d5eaeb6d"
    sha256 cellar: :any_skip_relocation, sonoma:         "f96a5f2c5007862b245fbb9dfe0150c54fc87c937b090b1cd50fc920940ddf33"
    sha256 cellar: :any_skip_relocation, ventura:        "24813015fac3e46553d96d509cd5aed18a46368360df4762305eae8d296f768b"
    sha256 cellar: :any_skip_relocation, monterey:       "6170ac5d268f978c1edc3acd105c3774cc694c1b9b73a748941c691d795e3a64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e496284a4727c7864db0e08694c01c08df637b2d9f332e8cb4402564eed2bef"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comnucleuscloudneosynccliinternalversion.gitVersion=#{version}
      -X github.comnucleuscloudneosynccliinternalversion.gitCommit=#{tap.user}
      -X github.comnucleuscloudneosynccliinternalversion.buildDate=#{time.iso8601}
    ]
    cd "cli" do
      system "go", "build", *std_go_args(ldflags:), ".cmdneosync"
    end

    generate_completions_from_executable(bin"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}neosync connections list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}neosync --version")
  end
end