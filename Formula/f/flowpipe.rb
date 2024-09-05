class Flowpipe < Formula
  desc "Cloud scripting engine"
  homepage "https:flowpipe.io"
  url "https:github.comturbotflowpipearchiverefstagsv0.9.0.tar.gz"
  sha256 "0ee184290b03806067a13e61b7725ee73c51dc76f5b88c2d6054bd204cd8e874"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9c30dc2f326d59155e9961da552008058770718dbc7d4cc5b2efb68ffca328df"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3892081fd6e4bb48cfe46e049818b067770526f6d42115a466b2441976e0fdaa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43ff1ba0ef17e613208ec42a76e0b523b9973a5c6c1f5d223d304bff08ac076a"
    sha256 cellar: :any_skip_relocation, sonoma:         "328a8677cd4ffe0433455273612137e4fc9ab2215450dc000b8117d6ddf4837f"
    sha256 cellar: :any_skip_relocation, ventura:        "316d2e4a1a088613c7e5e6f7c99c145f412d11be6b87ac6b7b554c1d5deedc0e"
    sha256 cellar: :any_skip_relocation, monterey:       "bdfee43d1f16cd8c37bff68a63b31cdfa9d828a80f36bfabf65b933244cc96b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1f38c55e39e9ac6e0b65072342687a54798946e55e8b7b4199a431ec6ca94d3"
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