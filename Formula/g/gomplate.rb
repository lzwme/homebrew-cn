class Gomplate < Formula
  desc "Command-line Golang template processor"
  homepage "https:gomplate.ca"
  url "https:github.comhairyhendersongomplatearchiverefstagsv4.0.0.tar.gz"
  sha256 "284437746f190da7453b73393b37bf6f8d7e68cfa1b0b2b5336596bcf99798af"
  license "MIT"
  head "https:github.comhairyhendersongomplate.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4601b7cf3a326817fe03081692a7a4c4c508eba712a10bbc9e895ef1fb269041"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d683ee96adfbb08068d53f1b08fdd5ad0a41d099234bce51525f24c9ca1a23cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "481b1775499d7de1e3bf3be583a96cb201a4834e50c2c11fea4dc507d6e28fd0"
    sha256 cellar: :any_skip_relocation, sonoma:         "7b9cbb066dc2d2cdd686ef74214b1943bef88a3933922c7105699695fc08fb07"
    sha256 cellar: :any_skip_relocation, ventura:        "3a4109c8be777bead46845e14580dbeafc1234350a3375b1b1456c2a2a21e1a6"
    sha256 cellar: :any_skip_relocation, monterey:       "8d56cdcfdc64b8fb979f429b3d377671911cd2ee38a79d9d5a595dfe2e7a7fa7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8271d4b1a03edad7e875e6416487df11a4b603a7684f83c102f516dc03d0ff0b"
  end

  depends_on "go" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "bingomplate" => "gomplate"
  end

  test do
    output = shell_output("#{bin}gomplate --version")
    assert_equal "gomplate version #{version}", output.chomp

    test_template = <<~EOS
      {{ range ("foo:bar:baz" | strings.SplitN ":" 2) }}{{.}}
      {{end}}
    EOS

    expected = <<~EOS
      foo
      bar:baz
    EOS

    assert_match expected, pipe_output("#{bin}gomplate", test_template, 0)
  end
end