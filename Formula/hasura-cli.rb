require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://ghproxy.com/https://github.com/hasura/graphql-engine/archive/v2.22.0.tar.gz"
  sha256 "fe64a92f03e4b3c019ade9afefaf0560471f3ca45d42e3179d576a0a91423555"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f5d8bb6cd2d89a2e46b7f2230b12ede3cf1365879ebe82ad832bc9b9292a8d76"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e0454c9dee206d242aab8efe2727911dcf2246897503d01fa6c1b27e889c06c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "131de38201f93247172402df4806d8b5ad71a0c4458419584bc9d557264bfb3b"
    sha256 cellar: :any_skip_relocation, ventura:        "fce5d9178dbf5c2d7fc93906f92282a25cf0c6c09a381b49d25a4418ae43345d"
    sha256 cellar: :any_skip_relocation, monterey:       "938cf0ca46b25650fec30384450ac3b15006e1323f10f7a505f479ef8adc42d2"
    sha256 cellar: :any_skip_relocation, big_sur:        "7d278472590b8d4832bdde8227fdd1f054e7cf37cfd02893c6a55b34c150ba99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b901c154610e955f608c2c9aac87cfc43542846cb5a466007f5bf76f3a08008"
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