class Flowpipe < Formula
  desc "Cloud scripting engine"
  homepage "https:flowpipe.io"
  url "https:github.comturbotflowpipearchiverefstagsv1.0.0.tar.gz"
  sha256 "c4d6f3f13de1b9027d2a9a33621afb16beb5b50c5586fb96b4ca1134d2521e92"
  license "AGPL-3.0-only"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4912a0ba4e81fe164fd5d22f6acaae197cc0d0f809734d1db780ff1117b1ae3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07ed17a1667c62c9d95bfda314cb3d183e5e2928123c25d91cbccd5e674b16c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ef27cf26884c8478c843590ed84dedf77bf23e29ac8bc949a1abac32d76eefa8"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fdf3f14c42a187e5f087743f7acf53e990303555427b3ded146557c828a4105"
    sha256 cellar: :any_skip_relocation, ventura:       "8096e2502189ee3d8103a398a8c63703e2e5df3edafbee623d3d5216aebab9ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7120e4d132f804a6b37ba253333056e3fe2c47ad0ce0a008da7585d2d89678ef"
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
    ENV["FLOWPIPE_INSTALL_DIR"] = testpath".flowpipe"
    ENV["FLOWPIPE_CONFIG_PATH"] = testpath

    (testpath"flowpipe_config.yml").write <<~EOS
      workspace:
        path: "#{testpath}workspace"
      mods: []
    EOS

    output = shell_output("#{bin}flowpipe mod list")
    assert_match "No mods installed.", output

    assert_match version.to_s, shell_output("#{bin}flowpipe -v")
  end
end