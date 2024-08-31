class Flowpipe < Formula
  desc "Cloud scripting engine"
  homepage "https:flowpipe.io"
  url "https:github.comturbotflowpipearchiverefstagsv0.8.1.tar.gz"
  sha256 "6e4eeba684ad59141099e1845e63c8f0528ac0456a4514fbd83c80b4dfb8d632"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7aa6daee289e0f562a4320402d075327446790d70c490da41f2d67d554b64c20"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "de79a7967e6e9b71533ef9a4f2ec0bd494eaa1813d0e19f9b1ceb33717524a2e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3afa87f5d4da88c24f311624a734f80ab7367301ac47006a48a8c6188084125"
    sha256 cellar: :any_skip_relocation, sonoma:         "c05ed1bb40023250ad5568721b00d217feccc4c814b1b904523991fa65326cc4"
    sha256 cellar: :any_skip_relocation, ventura:        "e4de50e3ffa4bf1115227a1caf17b3bc940902614227dcad7504a4d02513d85f"
    sha256 cellar: :any_skip_relocation, monterey:       "2deae734d630e8263cf33bf587283999d3bea71005d5797f30858b30f84eb2e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9577c90ccabc25a08f62ffab77b14dc8d951602c0f4664bdea142c6f4b97293e"
  end

  depends_on "corepack" => :build
  depends_on "go" => :build
  depends_on "node" => :build

  def install
    cd "uiform" do
      system "yarn", "install"
      system "yarn", "build"
    end

    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X version.buildTime=#{time.iso8601}
      -X version.commit=#{tap.user}
      -X version.builtBy=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}flowpipe -v")

    ret_status = OS.mac? ? 1 : 0
    output = shell_output(bin"flowpipe mod list 2>&1", ret_status)
    if OS.mac?
      assert_match "Error: could not create sample workspace", output
    else
      assert_match "No mods installed.", output
    end
  end
end