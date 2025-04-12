class Tendermint < Formula
  desc "BFT state machine replication for applications in any programming languages"
  homepage "https:tendermint.com"
  url "https:github.comtenderminttendermintarchiverefstagsv0.35.9.tar.gz"
  sha256 "8385fb075e81d4d4875573fdbc5f2448372ea9eaebc1b18421d6fb497798774b"
  license "Apache-2.0"
  head "https:github.comtenderminttendermint.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "1511d60c1245cac653fda123d49181a5041a49edfc6c33649161c032035a5d1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "68ef6b0500008a57a4bd732acfdb8e8952f4de2832742cb8b4979be3bdde5089"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa03d9507cc713dc1d85b03a5374f52f0b1fa9a8bdeff7f04fabb0ce54158ac4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa03d9507cc713dc1d85b03a5374f52f0b1fa9a8bdeff7f04fabb0ce54158ac4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fa03d9507cc713dc1d85b03a5374f52f0b1fa9a8bdeff7f04fabb0ce54158ac4"
    sha256 cellar: :any_skip_relocation, sonoma:         "b19905fb5656c1f5412b8d669f7eaa43ff73b54825b5379b4964b3561b3b59ae"
    sha256 cellar: :any_skip_relocation, ventura:        "c764c958d1586a5fcf8a8ba7ede5c8edd7f350dec38689c13fd61d6e00154a3d"
    sha256 cellar: :any_skip_relocation, monterey:       "c764c958d1586a5fcf8a8ba7ede5c8edd7f350dec38689c13fd61d6e00154a3d"
    sha256 cellar: :any_skip_relocation, big_sur:        "c764c958d1586a5fcf8a8ba7ede5c8edd7f350dec38689c13fd61d6e00154a3d"
    sha256 cellar: :any_skip_relocation, catalina:       "c764c958d1586a5fcf8a8ba7ede5c8edd7f350dec38689c13fd61d6e00154a3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "50a1fe51c2ba29d7b0bda7a8b103a950cad2267f1e859cb525bd51b989bc91f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fad00242ca40a9571b66d96a4f31268ee81fa317726834d82475630267d9ef13"
  end

  depends_on "go" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "buildtendermint"

    generate_completions_from_executable(bin"tendermint", "completion",
                                         shells: [:bash], shell_parameter_format: :none)
    generate_completions_from_executable(bin"tendermint", "completion", "--zsh",
                                         shells: [:zsh], shell_parameter_format: :none)
  end

  test do
    mkdir(testpath"staging")
    shell_output("#{bin}tendermint init full --home #{testpath}staging")
    assert_path_exists testpath"stagingconfiggenesis.json"
    assert_path_exists testpath"stagingconfigconfig.toml"
    assert_path_exists testpath"stagingdata"
  end
end