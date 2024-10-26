class Flowpipe < Formula
  desc "Cloud scripting engine"
  homepage "https:flowpipe.io"
  url "https:github.comturbotflowpipearchiverefstagsv1.0.1.tar.gz"
  sha256 "d911d652e8d5c35f9aa4f65997269d0ed46f71175f8c6c83c8934745ead683bf"
  license "AGPL-3.0-only"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59f1536fb04247694c43f4ffb104cc4201d6f551a3573654b7a02bf0421afa9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "333418eb7f0a0d2a457d8cf4778a5f24f3441f5d0014a5292fcc1013e7f9ec01"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5bba7fe16cfbd4cd143a29371cfcd0dbb90ea48701df1ed7ca904595ec9135a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a394399a0b7f562e4786adb4a8b058361235de871050e98800c775970f6843a"
    sha256 cellar: :any_skip_relocation, ventura:       "077212975697fb8ea0e318583896682abab386f6b8b65e5c91081c64226b306a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "716ed32b0fd61be265b62e347a21c1a219a3200434ae94400f22617a4fbfe044"
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