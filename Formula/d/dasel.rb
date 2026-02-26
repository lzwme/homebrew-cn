class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://ghfast.top/https://github.com/TomWright/dasel/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "0dcf0cfc475df6b7600858ea93dc145bb025c08957dc6e964480f184b5ace528"
  license "MIT"
  head "https://github.com/TomWright/dasel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b6684fa6cbd0d5cdb36f65c997ba6b34db33143e5f94db4db8c01ff67225d313"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6684fa6cbd0d5cdb36f65c997ba6b34db33143e5f94db4db8c01ff67225d313"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6684fa6cbd0d5cdb36f65c997ba6b34db33143e5f94db4db8c01ff67225d313"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a4c10f100cae6b3099cd441f32865af9adcb8a9466b4d346901e03295ecbdd5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "358ae8c71bf907c86e5e0312eea1dd03cbfac7fb406c88b9ae8ff30caf51ad86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b263f2ab1b5d548d90d99eb2022ce08a0b033a3ac9afacf3ff27bdd4bc513e8"
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