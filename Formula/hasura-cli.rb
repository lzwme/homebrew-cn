require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://ghproxy.com/https://github.com/hasura/graphql-engine/archive/v2.25.0.tar.gz"
  sha256 "0abe73f2fb2790ae8f0aef9c280b0a8beb9496cffc5c666b95f2f86eb72b5d9f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "84bb56c99d2f2e2374ca66754524c556dcc73177a5c5094b0f26c8f865b581d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67833ac6765584bee4e4bf5171eda68b23d96448367a60b75c17907b00597b01"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe7508a0e3a11faae42bd076db5a15807c7036c213dea183f886224b07040932"
    sha256 cellar: :any_skip_relocation, ventura:        "5d5d218d06c1a9466ceface2dbeca80b6e527b79ae0dc4d500e550db01be3ddb"
    sha256 cellar: :any_skip_relocation, monterey:       "8ea3167ea639168c2670bf44d9a21054cf9edd751e2e39247e328a152a11d489"
    sha256 cellar: :any_skip_relocation, big_sur:        "4e536b220ec4b679a0bb2522c629b20b17e576a006525df5b2968dc5e9f631e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11b191e86e044f86a05f84c55b408b8f2d4331411af501106cb5a3712f3e3438"
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