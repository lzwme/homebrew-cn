class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.40.tar.gz"
  sha256 "181df76baa0211522af63cd93a4d974afec204eb8dc04bba1e3e8da21c9c605b"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4c9feb5aeb940fc184c72c76805f1d050648dbf2140f568e5db7d9447e1e9b02"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be9b748daef11ead2c5f9deeac89630bee9d5c4bdc065c4770a41116de0cd7e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f8ded9c0f22a218d86a00987c3866ab544e8ec8da5effa4f26be5748979f692"
    sha256 cellar: :any_skip_relocation, sonoma:         "067cb61580dc933305e3e852b0ac6d704e5d3e80ed73b5d0e5430c5475f54334"
    sha256 cellar: :any_skip_relocation, ventura:        "322283213555ad60302c7e23a3efd78c95b018fe22b2c5a98106bb4150650d61"
    sha256 cellar: :any_skip_relocation, monterey:       "3fbb9b20881ccfb33833cf16d2c22d18cfe157582e7648e9bf0b155885cde40e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f9f762e5f5d5e85476909dde816717e59e0b5644c9174dd6093b40faa0585d6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comnucleuscloudneosynccliinternalversion.gitVersion=#{version}
      -X github.comnucleuscloudneosynccliinternalversion.gitCommit=#{tap.user}
      -X github.comnucleuscloudneosynccliinternalversion.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), ".clicmdneosync"

    generate_completions_from_executable(bin"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}neosync connections list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}neosync --version")
  end
end