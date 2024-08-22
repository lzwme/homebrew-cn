class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https:steampipe.io"
  url "https:github.comturbotsteampipearchiverefstagsv0.23.5.tar.gz"
  sha256 "b1029fd702c16166e863e2e6b447dea489cd36abdc7a9e1b17ec1094391f6cd0"
  license "AGPL-3.0-only"
  head "https:github.comturbotsteampipe.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2605411aed63d982976f7d2b04910f89028004a838b9675bd15ec48c3abca9f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "31d4f4ed4e4e126d845da3a94464018325498f5aad3e7b06118406a8f4a38feb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d38adeb683ddf6d27879af418017dd51be8aba5b38f4e051c084b881e06df48"
    sha256 cellar: :any_skip_relocation, sonoma:         "1be8d3c287b0bd70d458b208a01dde3402b6b7ca2fdfb130f8c74735bed0685f"
    sha256 cellar: :any_skip_relocation, ventura:        "d46848ff7d077611f931921758556654286127001d0a48b6e27dfa64196fe67b"
    sha256 cellar: :any_skip_relocation, monterey:       "959abb58d02d674ce7608a4aa44a8d8a3c0cb8bbfacb3a177b971dace234823e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "119f811891ea6c75bddf3058127a7111623fdf457b5fb9d8e638732e66b0eab8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin"steampipe", "completion")
  end

  test do
    if OS.mac?
      output = shell_output(bin"steampipe service status 2>&1", 255)
      assert_match "Error: could not create sample workspace", output
    else # Linux
      output = shell_output(bin"steampipe service status 2>&1")
      assert_match "Steampipe service is not installed", output
    end
    assert_match "Steampipe v#{version}", shell_output(bin"steampipe --version")
  end
end