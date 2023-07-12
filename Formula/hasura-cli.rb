require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://ghproxy.com/https://github.com/hasura/graphql-engine/archive/v2.29.1.tar.gz"
  sha256 "70cb99fd2be3f19dc35ab0ad013a242f1c8951e234b5874fc19fee1d54ace8f3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4149ba48105192464276bbc0af293ea010fd16f46b8cbb9e61275b55815da1fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "484f2297d4cb19f31c94ac1dbc48a68c57e9cb9ac160d193a5071687e51a5011"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8b0bbd129d10ac7b5a2ffc41d11ad0693a85b15fbfe9c2cb7c965ebaf36d8513"
    sha256 cellar: :any_skip_relocation, ventura:        "b4943ef9557e5e60462822b625ec4bbdab14d4ba53e6f94ae8bff0bec0d065ba"
    sha256 cellar: :any_skip_relocation, monterey:       "82f608786b17a10b02e70451ed01351ea3a2fd8470c2515ba7b763598f56912e"
    sha256 cellar: :any_skip_relocation, big_sur:        "e34bba38971a227abcb71020086dac0767bf0f03653d0bbd294d7acd27ef9bd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4929f444d574c6a4522fe087052cf19466f4ba3fcddbd7092e9aa48d339d5a43"
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