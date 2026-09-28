class Fracturedjson < Formula
  desc "JSON formatter that produces highly readable but fairly compact output"
  homepage "https://github.com/j-brooke/FracturedJson"
  url "https://ghfast.top/https://github.com/j-brooke/FracturedJson/archive/refs/tags/cli-v1.1.0.tar.gz"
  sha256 "0b6efec044f5c7d738f837124cdf5fc9d3b94864be8a9b07c2de8ffe22e2235a"
  license "MIT"

  livecheck do
    url :stable
    regex(/cli[._-]v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e8adda3b3832506cc4ded6d7b28edad8fc15ab7709a9e503bcd735451bf81ab5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f3f8570519d75f23aa9c577b20f6f56bac177781fff191bab9484b6850f3c5f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d43a181c4c59244a196430507ab6b573ce64c98f9b83d4d569a9c70a5eb06e50"
    sha256 cellar: :any,                 arm64_linux:       "6de70475655e71fe8b9f3aa0f976c504e7fc76a0dac6bd8959f1c3e6bd7fb609"
    sha256 cellar: :any,                 x86_64_linux:      "d798f9509531b3f2dd32a4eb9a5ec6c7d09c28c30f64d0657bc8f647951071d9"
  end

  depends_on "dotnet" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    os_tag = OS.mac? ? "osx" : "linux"
    args = %W[
      --configuration Release
      --runtime #{os_tag}-#{arch}
      --output #{libexec}
      --property InvariantGlobalization=true
    ]
    system "dotnet", "publish", "Cli/Cli.csproj", *args
    bin.install_symlink libexec/"fracjson"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fracjson --version")

    input_json = <<~JSON
      {"BasicObject":{"ModuleId":"armor","Locations":[[11,2],[11,3],[11,4],[11,5],[11,6],[11,7],[11,8],[11,9],[11,10],[11,11],[11,12],[11,13],
      [11,14],[1,14],[1,13],[1,12],[1,11],[1,10],[1,9],[1,8],[1,7],[1,6],[1,5],[1,4],[1,3],[1,2],[4,2],[5,2],[6,2],[7,2]],"Seed":272691529},
      "SimilarArrays":{"Katherine":["blue","lightblue","black"],"Logan":["yellow","blue","black","red"],"Erik":["red","purple"]}}
    JSON
    output = pipe_output("#{bin}/fracjson", input_json, 0).chomp
    assert_operator output.lines.count, :>, 3
  end
end