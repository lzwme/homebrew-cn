class Flowpipe < Formula
  desc "Cloud scripting engine"
  homepage "https:flowpipe.io"
  url "https:github.comturbotflowpipearchiverefstagsv0.2.1.tar.gz"
  sha256 "1df24441d2fbe999db5325fd96a1351fafdedda7540a9c1289e6b5697495b9f1"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "87746b0f200057b6625f79cdcd47a18476b1e7bd0c06d1b4ac4ce48c5b956207"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ad130ccd16cb12ad5272aed7e4dca289a18a282333697d3dbd7d59b42befcfa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27a04464fcc5c4f3868a39bc08be56366e33c57c4dd68a92d186bc6edc1561f4"
    sha256 cellar: :any_skip_relocation, sonoma:         "ef1fb692c6fe5bd7e69db769ff3bd1cbf03180854406a006ae4cf90a20aa8c10"
    sha256 cellar: :any_skip_relocation, ventura:        "77c6a9e47e18efcf08c5fc0faa50dde982da5d246c69e2fdaed87d68a041e231"
    sha256 cellar: :any_skip_relocation, monterey:       "124548e3b6af0cf04ed2becaf51df2bf62c70f73e7496050eb73b4d5eb3b4499"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c5f140bb150ffde830d66340b8cef3c05b94252e5e839b447a2e33c95ad0079"
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