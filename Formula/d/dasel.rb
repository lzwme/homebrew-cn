class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://ghfast.top/https://github.com/TomWright/dasel/archive/refs/tags/v3.3.1.tar.gz"
  sha256 "0d83ee2235b2698ae84402cc03f0e3880a7b8e132408d5b45d02d544da894abc"
  license "MIT"
  head "https://github.com/TomWright/dasel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d002a98797ee44628fd3338bcf03d62f65c1c6446794e69e3929b80e952ba765"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d002a98797ee44628fd3338bcf03d62f65c1c6446794e69e3929b80e952ba765"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d002a98797ee44628fd3338bcf03d62f65c1c6446794e69e3929b80e952ba765"
    sha256 cellar: :any_skip_relocation, sonoma:        "42ed0e8bdf37a9e1f53790e4477918c61a3a2528070339f5e86b642da69b821e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c49c88313c29c180c6a84d8a67ea9526575ed178fb69c11b9fdc86756a8fed9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c4ae5831bd03cb6c0e8cf027f336cd7ea4fe33f9b7a7d8e77b2bdfcdba4fd61"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/tomwright/dasel/v#{version.major}/internal.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/dasel"
  end

  test do
    assert_equal "\"Tom\"", pipe_output("#{bin}/dasel -i json 'name'", '{"name": "Tom"}', 0).chomp
    assert_match version.to_s, shell_output("#{bin}/dasel version")
  end
end