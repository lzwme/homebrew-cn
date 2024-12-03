class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https:hasura.io"
  url "https:github.comhasuragraphql-enginearchiverefstagsv2.45.0.tar.gz"
  sha256 "41930616522d67cd74077d85f3fa353ca934dbb8d6ff3fcb65acf5d53bcb7b4f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61c4be276a75d76d3f4a62bab379322b2c823b3124c667300ee9f1ef57d2c164"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61c4be276a75d76d3f4a62bab379322b2c823b3124c667300ee9f1ef57d2c164"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "61c4be276a75d76d3f4a62bab379322b2c823b3124c667300ee9f1ef57d2c164"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d7c2b8462289cbbdc32fb42675f4e149df22f8bac39197fa49fb8fed0095cf5"
    sha256 cellar: :any_skip_relocation, ventura:       "3d7c2b8462289cbbdc32fb42675f4e149df22f8bac39197fa49fb8fed0095cf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f427c10d211cde786270dc8fdb5c43b1feb9b736f9f483cbe6f6e83dd07c3210"
  end

  deprecate! date: "2024-10-29", because: "uses `node@18`, which is deprecated"

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