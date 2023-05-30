require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://ghproxy.com/https://github.com/hasura/graphql-engine/archive/v2.26.0.tar.gz"
  sha256 "d5b068d10aab8a434d76ffd728206e7abd12db0221104b306458a5e647059cc8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f9b5c04d82b1e27129eb5cf4995ed166c3a8d44ebf12e5d19d546ea20996ac84"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8896da3918af52756ae9766d2127c60329818a0a26baf89afc6170c695b6519b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "16842168fcd92ae5fa830e519294a5efba58cf244973a3de853cd4459733031a"
    sha256 cellar: :any_skip_relocation, ventura:        "0bd9a29a67b9dd1901de5327467db3e4df7a40a8109a83526f597922c3d49d13"
    sha256 cellar: :any_skip_relocation, monterey:       "398e97aa8c8ff62e813c49cdf7ebfa3419aec6bdd98a55f630ded7299d642879"
    sha256 cellar: :any_skip_relocation, big_sur:        "26f0431a5b42b7714f22fd4a501e15f9796675c3349bf58eaa86d7ce92935451"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "671085cee54fd1bda079815e47626ae2ff002c8846e83f66fb519fdbccf44d00"
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