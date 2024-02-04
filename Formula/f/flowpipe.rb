class Flowpipe < Formula
  desc "Cloud scripting engine"
  homepage "https:flowpipe.io"
  url "https:github.comturbotflowpipearchiverefstagsv0.2.2.tar.gz"
  sha256 "5d84bfc816b38c38bbc88ee85fffe32a21b54ba9d17e0f7e0703ad48ad5b4229"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "43d0ceea6342b55c83c953946ebacfa23788903b9aaa460979b24ff6311a9655"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08e33c24dee3517075c28ae6e7edc006047971fb21d96947113f4ebf8e6380b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed15c7b7f7ad294f15c1308ea7f657d13408fd174659728dca0e155699adc211"
    sha256 cellar: :any_skip_relocation, sonoma:         "30f08e9aca8d2fa09956cf80ad863e05cf51363c205ca4457f05aff4354d3091"
    sha256 cellar: :any_skip_relocation, ventura:        "af55d0048b19cc4d1dd2e9bd791193ea2c8caef41bb3b2e386fe7733b620a409"
    sha256 cellar: :any_skip_relocation, monterey:       "bc6c877c9890ec17e9f5bbe23987639e6c06c45ba3c3b6c71540094c6196a011"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23a4523949e9b3eb5e25f4665aea54d317dcc6170b9b05a5cf658f212af11e02"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X version.buildTime=#{time.iso8601}
      -X version.commit=#{tap.user}
      -X version.builtBy=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}flowpipe -v")

    output = shell_output(bin"flowpipe mod list 2>&1")
    if OS.mac?
      assert_match "Error: could not create sample workspace", output
    else
      assert_match "No mods installed.", output
    end
  end
end