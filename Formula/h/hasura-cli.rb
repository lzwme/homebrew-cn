class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https:hasura.io"
  url "https:github.comhasuragraphql-enginearchiverefstagsv2.41.0.tar.gz"
  sha256 "4f32574148b344e4dd59c9708dc959f29a1fa050c5e7790e82523eb51ef0ae22"
  license "Apache-2.0"
  head "https:github.comhasuragraphql-engine.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d86e8d061a314addf8afd0723b1f3e089be3948216ef9a6563cce7b0360bac27"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "746dfe36905caad3a6101ac38cc251510e2fe59c17d3dc1432d6fe5c5c7622fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed5c8fd5bd56ed46841ebc0e25e79af48876e30316c6d0cdd06ece5b92ba655f"
    sha256 cellar: :any_skip_relocation, sonoma:         "999fb29b2ff01854e84af50bc4a2a2a2c80ec1e18257e56755483431f3d70676"
    sha256 cellar: :any_skip_relocation, ventura:        "f72c9e64aca5043a47bea23b03f743653084ea728cb8649710a2e9b6a21dfe06"
    sha256 cellar: :any_skip_relocation, monterey:       "3bba3b885ede9948c3d7f493819f769a8c420661c30a7579df23d9b54cf50d3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3d9c249f2f959ab8764d4302be8ed6ae9f189eb57a05b022248f63aa0f188e4"
  end

  depends_on "go" => :build
  depends_on "node@18" => :build

  def install
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    os = OS.kernel_name.downcase

    # Based on `make build-cli-ext`, but only build a single host-specific binary
    cd "cli-ext" do
      # TODO: Remove `npm add pkg` when https:github.comhasuragraphql-engineissues9440 is resolved.
      system "npm", "add", "pkg@5.8.1"
      system "npm", "install", *std_npm_args(prefix: false)
      system "npm", "run", "prebuild"
      dest = ".cliinternalcliextstatic-bin#{os}#{arch}cli-ext"
      system "npx", "pkg", ".buildcommand.js", "--output", dest, "-t", "host"
    end

    ldflags = %W[
      -s -w
      -X github.comhasuragraphql-enginecliv2version.BuildVersion=#{version}
      -X github.comhasuragraphql-enginecliv2plugins.IndexBranchRef=master
    ]
    cd "cli" do
      system "go", "build", *std_go_args(output: bin"hasura", ldflags:), ".cmdhasura"
    end

    generate_completions_from_executable(bin"hasura", "completion", base_name: "hasura", shells: [:bash, :zsh])
  end

  test do
    system bin"hasura", "init", "testdir"
    assert_predicate testpath"testdirconfig.yaml", :exist?
  end
end