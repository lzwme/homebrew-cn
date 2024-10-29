class Flowpipe < Formula
  desc "Cloud scripting engine"
  homepage "https:flowpipe.io"
  url "https:github.comturbotflowpipearchiverefstagsv1.0.2.tar.gz"
  sha256 "5e8a54ae8f26de64c7b0ee906bebe36396364ea3d7f2c9098ecf9585ba916f77"
  license "AGPL-3.0-only"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc55463b2e57142c31f20e3a79a920aca266acf63d0d86ccd1a1ed05b4f2b766"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2326c6d402c0d4190700cb93abca15c4f365a1d0a80708216092d50a8556f6b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "446396483feccbfead6753687098a7ef377a258593b3f6c2dbec93ea91c66a9a"
    sha256 cellar: :any_skip_relocation, sonoma:        "223803a8a3fd787e5b065f308e3e49da0678059321467033ec203ded31cae0e8"
    sha256 cellar: :any_skip_relocation, ventura:       "c0afd6b380a527805d1122c6957bbe6d707b0d82b86ea3c0d6574f4578d6ea0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9cb0359f1eea710d15fee1f34dd57d22b545710ddc06c8d6f42c22d4fd00ba0"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    ENV["COREPACK_ENABLE_DOWNLOAD_PROMPT"] = "0"

    system "corepack", "enable", "--install-directory", buildpath

    cd "uiform" do
      system buildpath"yarn", "install"
      system buildpath"yarn", "build"
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