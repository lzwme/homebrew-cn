require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://ghproxy.com/https://github.com/hasura/graphql-engine/archive/v2.33.0.tar.gz"
  sha256 "16c8b0016897e1a333124f18ff3cdd4a6806a5c88ead343a3f18318b228a185b"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9aee52289e6fdb6a4f00f7f979a9ea5496de1df1c4b6d01f4d09c73d871b1e68"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2b372d6f0ac0ca7040294150d07541fd5c3b3b2f4517d53baadf8344a527cd0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "211864d6290fb44cbfb3ce2b327761b8c98bf57e8bf8595177c8227669cc57d1"
    sha256 cellar: :any_skip_relocation, ventura:        "6ddcd7c43a4f7e5bd65fc4f4990f32e29fbb887ebf7241126aa4b27d9f35b6a1"
    sha256 cellar: :any_skip_relocation, monterey:       "8a318ecf3e63173868204d3840ebcf6de0404810ac62e822fdb165774254c5e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "8648d2b987660e07fbf62795d44a7e50b9ca9e43f6a4e86e0182f2115b659804"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f31c2163780298a20f82a953c4826ae10bdabdb41810c2c516127ff6d7410246"
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