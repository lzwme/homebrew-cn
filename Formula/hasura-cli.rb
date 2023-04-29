require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://ghproxy.com/https://github.com/hasura/graphql-engine/archive/v2.24.1.tar.gz"
  sha256 "e6b3a3b479c98c7e54a0005cd095a7569ea71909b8f0364de42f1776365fd89f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a2bbfa40d6b165bdea63fbec3f7bc0c0f312c42c3b92a1e04c7e2c180aac424"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b588269188f5642ccb108a02233cf7c53e433696c2e6b542e6daa8a5551b77c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9bc95a2faa05aa3cc6c1c716eadeb2a9b45c8a74cf16ee7314fdd43c511b20fa"
    sha256 cellar: :any_skip_relocation, ventura:        "136ebaec59954be2c1972c9ca499637c2090aa50a577c5fcf71a61151af5ccde"
    sha256 cellar: :any_skip_relocation, monterey:       "a81b2fdc77a5b77f10727e89b747e15a994528e081287533496306a4e777e02c"
    sha256 cellar: :any_skip_relocation, big_sur:        "c5b9ce7853918153bfe8e2133bd30c313eab835ffd2771a19ab0d9dbac8f9614"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "130704b912d1ec6c3e691dbcd3a109333556972459e8bccc13622ca23efc73b6"
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