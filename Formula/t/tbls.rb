class Tbls < Formula
  desc "CI-Friendly tool for document a database"
  homepage "https:github.comk1LoWtbls"
  url "https:github.comk1LoWtblsarchiverefstagsv1.72.1.tar.gz"
  sha256 "16456bcf14f48ea174126322b171a8c7e6e9fcd2340ab4b0edcce16212516aa7"
  license "MIT"
  head "https:github.comk1LoWtbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f4c393cbecfd9e309cb8b190caadd299fdf998a794923b6ad2ea2756026ad4ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5317c039a0b99c2393ec66243e32fe23b9cf605dc64cc9524b7fb76861021f76"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "edfadd205ddd9057fe52e079e1f71332d8969f32595b1add2b1d91c2e168b07b"
    sha256 cellar: :any_skip_relocation, sonoma:         "c83f81f34c02342ff94f72eafa303cd0b440ddbb87b46744944f2e2e77b528db"
    sha256 cellar: :any_skip_relocation, ventura:        "a75ee901b6918076c06b06f7fcf93ee313415c17fb2701a7c475ea781456975a"
    sha256 cellar: :any_skip_relocation, monterey:       "2eaa30d45fad7ddd8a5de7e89d4827cfe1d8875d1a1d27a4728894813fda4042"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96df9ac8dcf8ae88365bcd2a662b2ddf7cfbb79ca505ffaf27f862b5b56c4150"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comk1LoWtbls.version=#{version}
      -X github.comk1LoWtbls.date=#{time.iso8601}
      -X github.comk1LoWtblsversion.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin"tbls", "completion")
  end

  test do
    assert_match "invalid database scheme", shell_output(bin"tbls doc", 1)
    assert_match version.to_s, shell_output(bin"tbls version")
  end
end