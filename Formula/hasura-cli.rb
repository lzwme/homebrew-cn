require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://ghproxy.com/https://github.com/hasura/graphql-engine/archive/v2.30.1.tar.gz"
  sha256 "19c0c7b9834937522a9df3a092dda7f9bcd0c52d6a2309cc2f64b0191a470899"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5928ffd7ec39a7668057a55c156c77d86fbdcfe4e4d60ed36b5e7e1a7eea90bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4571acd1a3f9a746ed7c6729249983ff6c652a16f5d29b81b4823b81725992c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b556c6b18cb3f5361972c53ff1199f3d2c9434397cad3d2e8c8ee1410b2d2c56"
    sha256 cellar: :any_skip_relocation, ventura:        "a0fa0936f67556697fe037445930ca80d2d800abd1fa5d2912ff47e90118db4e"
    sha256 cellar: :any_skip_relocation, monterey:       "81bd4413a71e70a6f3a8478c0a06eac1b7306b4920e308e65c292dc6e46966d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "8861337b482c14d2433b874c47d98b206168519a362982c9a6ddcb6dcc0361b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55a7df8b590e089688370f73ef848e2371c4674286c470dea8065f8ea2cda121"
  end

  depends_on "go" => :build
  depends_on "node@18" => :build

  def install
    Language::Node.setup_npm_environment

    ldflags = %W[
      -s -w
      -X github.com/hasura/graphql-engine/cli/v2/version.BuildVersion=#{version}
      -X github.com/hasura/graphql-engine/cli/v2/plugins.IndexBranchRef=master
    ]

    # Based on `make build-cli-ext`, but only build a single host-specific binary
    cd "cli-ext" do
      # TODO: Remove `npm update pkg` when https://github.com/hasura/graphql-engine/issues/9440 is resolved.
      system "npm", "update", "pkg"
      system "npm", "install", *Language::Node.local_npm_install_args
      system "npm", "run", "prebuild"
      system "./node_modules/.bin/pkg", "./build/command.js", "--output", "./bin/cli-ext-hasura", "-t", "host"
    end

    cd "cli" do
      arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
      os = OS.kernel_name.downcase

      cp "../cli-ext/bin/cli-ext-hasura", "./internal/cliext/static-bin/#{os}/#{arch}/cli-ext"
      system "go", "build", *std_go_args(output: bin/"hasura", ldflags: ldflags), "./cmd/hasura/"

      generate_completions_from_executable(bin/"hasura", "completion", base_name: "hasura", shells: [:bash, :zsh])
    end
  end

  test do
    system bin/"hasura", "init", "testdir"
    assert_predicate testpath/"testdir/config.yaml", :exist?
  end
end